package com.example.studuler

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.FirebaseApp
import com.google.firebase.messaging.FirebaseMessaging
import android.util.Log

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Firebase 초기화
        FirebaseApp.initializeApp(this)

        // FirebaseMessaging 토큰 가져오기
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (!task.isSuccessful) {
                Log.w("MainActivity", "Fetching FCM registration token failed", task.exception)
                return@addOnCompleteListener
            }

            // FCM 토큰 로그 출력
            val token = task.result
            Log.d("MainActivity", "FCM Token: $token")
        }
    }
}
