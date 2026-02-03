package com.example.youpaint

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Rect
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.media.MediaMuxer
import android.view.Surface
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException
import java.nio.ByteBuffer

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.youpaint/video_export"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "createVideoFromImages") {
                val imagePaths = call.argument<List<String>>("imagePaths")
                val outputPath = call.argument<String>("outputPath")
                val fps = call.argument<Int>("fps")
                val width = call.argument<Int>("width")
                val height = call.argument<Int>("height")

                if (imagePaths != null && outputPath != null && fps != null && width != null && height != null) {
                    Thread {
                        try {
                            createVideo(imagePaths, outputPath, fps, width, height)
                            runOnUiThread { result.success(null) }
                        } catch (e: Exception) {
                            runOnUiThread { result.error("VIDEO_ERROR", e.message, null) }
                        }
                    }.start()
                } else {
                    result.error("INVALID_ARGUMENTS", "Missing arguments", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun createVideo(imagePaths: List<String>, outputPath: String, fps: Int, width: Int, height: Int) {
        val file = File(outputPath)
        if (file.exists()) {
            file.delete()
        }

        val mediaMuxer = MediaMuxer(outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
        val videoFormat = MediaFormat.createVideoFormat(MediaFormat.MIMETYPE_VIDEO_AVC, width, height)
        videoFormat.setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface)
        videoFormat.setInteger(MediaFormat.KEY_BIT_RATE, 2000000)
        videoFormat.setInteger(MediaFormat.KEY_FRAME_RATE, fps)
        videoFormat.setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)

        val encoder = MediaCodec.createEncoderByType(MediaFormat.MIMETYPE_VIDEO_AVC)
        encoder.configure(videoFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        val inputSurface = encoder.createInputSurface()
        encoder.start()

        var trackIndex = -1
        var muxerStarted = false
        val bufferInfo = MediaCodec.BufferInfo()
        val frameDurationMs = 1000L / fps
        var presentationTimeUs = 0L

        for (path in imagePaths) {
            val bitmap = BitmapFactory.decodeFile(path) ?: continue
            
            // Draw to surface
            val canvas = inputSurface.lockCanvas(null)
            try {
                canvas.drawBitmap(bitmap, null, Rect(0, 0, width, height), null)
            } finally {
                inputSurface.unlockCanvasAndPost(canvas)
            }
            bitmap.recycle()

            presentationTimeUs += (frameDurationMs * 1000)
            
            // Drain encoder
            drainEncoder(encoder, mediaMuxer, bufferInfo, false, trackIndex) { newIndex ->
                trackIndex = newIndex
                muxerStarted = true
            }
        }

        // End of stream
        encoder.signalEndOfInputStream()
        drainEncoder(encoder, mediaMuxer, bufferInfo, true, trackIndex) { newIndex ->
            trackIndex = newIndex
            muxerStarted = true
        }

        encoder.stop()
        encoder.release()
        if (muxerStarted) {
            mediaMuxer.stop()
        }
        mediaMuxer.release()
    }

    private fun drainEncoder(
        encoder: MediaCodec,
        muxer: MediaMuxer,
        bufferInfo: MediaCodec.BufferInfo,
        endOfStream: Boolean,
        currentTrackIndex: Int,
        onTrackStarted: (Int) -> Unit
    ) {
        val TIMEOUT_USEC = 10000L
        var trackIndex = currentTrackIndex

        while (true) {
            val encoderStatus = encoder.dequeueOutputBuffer(bufferInfo, TIMEOUT_USEC)
            if (encoderStatus == MediaCodec.INFO_TRY_AGAIN_LATER) {
                if (!endOfStream) break else continue
            } else if (encoderStatus == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED) {
                if (trackIndex >= 0) {
                    throw RuntimeException("format changed twice")
                }
                val newFormat = encoder.outputFormat
                trackIndex = muxer.addTrack(newFormat)
                muxer.start()
                onTrackStarted(trackIndex)
            } else if (encoderStatus < 0) {
                // ignore
            } else {
                val encodedData = encoder.getOutputBuffer(encoderStatus)
                    ?: throw RuntimeException("encoderOutputBuffer $encoderStatus was null")

                if ((bufferInfo.flags and MediaCodec.BUFFER_FLAG_CODEC_CONFIG) != 0) {
                    bufferInfo.size = 0
                }

                if (bufferInfo.size != 0) {
                    if (trackIndex < 0) {
                         // Muxer hasn't started yet, wait for format change
                        // This technically shouldn't happen if we handle FORMAT_CHANGED correctly
                    } else {
                        encodedData.position(bufferInfo.offset)
                        encodedData.limit(bufferInfo.offset + bufferInfo.size)
                        muxer.writeSampleData(trackIndex, encodedData, bufferInfo)
                    }
                }

                encoder.releaseOutputBuffer(encoderStatus, false)

                if ((bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM) != 0) {
                    break
                }
            }
        }
    }
}
