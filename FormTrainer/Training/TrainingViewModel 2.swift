//
//  TrainingViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/13.
//

import Foundation
import AVFoundation
import CoreMotion

class TrainingViewModel: ObservableObject {
    
    @Published var setMaxCount = ["プランク": 3, "バックスクワット": 3, "腹筋":3, "バックプランク": 3, "スクワット": 3, "腕立て": 3]
    @Published var trainingMaxCount = ["プランク": 60.0, "バックスクワット": 10.0, "腹筋":10.0, "バックプランク": 10.0, "スクワット": 10.0, "腕立て": 10.0]
    
    @Published var nowTrainingCount = 0.0
    @Published var nowSetCount = 0
    @Published var interbalTime = 10
    
    
    
    // タイマー
    var trainingTimer: Timer?
    var speakTimer: Timer?
    var stopSpeacTimer: Timer?
    var pauseTimer: Timer?
    
    // トレーニング前、トレーニング時、トレーニング後のViewフラグ
    var trainingFinish = false
    
    // セット、トレーニング終了判定
    @Published var trainingSucess = -1
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    var nowMenu = "プランク"
    
    var trainingIndex: Dictionary<String, Double>.Index?
    var setIndex: Dictionary<String, Int>.Index?
    
    //トレーニングの上下判定
    @Published var sensorjudge = false
    
    
    // センサーの値
    var x = 0.00
    var y = 0.00
    var z = 0.00
    
    // 音声
    private var speechSynthesizer : AVSpeechSynthesizer!
    
    @Published var sensor: [(menuName: String, maxSensor: Double, minSensor: Double)] = [("プランク", -0.08, -0.12),("バックプランク", -0.03, 0.34)]
    
    func initMenu(countMenu: [Int], setMenu: [Int], menu: [String], name: String) {
          
        for i in 0..<countMenu.count {
            
            trainingMaxCount.updateValue(Double(countMenu[i]), forKey: menu[i])
            setMaxCount.updateValue(setMenu[i], forKey: menu[i])
            
        }
    }
    
    // メニューごとの回数表示
    func menuCheck(name: String, countMenu: [String: Double], setMenu: [String: Int], index: String) -> Int {
        nowMenu = name
        trainingIndex = trainingMaxCount.index(forKey: nowMenu)
        setIndex = setMaxCount.index(forKey: nowMenu)
        if index == "set" {
            return Int(setMenu[setIndex!].value)
        } else {
            return Int(countMenu[trainingIndex!].value)
            
        }
    }
    
    // メニューごとに秒数か回数かを表示
    func plankCheck(name: String, parts: String) -> String {
        switch(parts) {
        case "のこり":
            if name == "プランク" || name == "バックプランク" {
                return "のこり"
            }
            return ""
        case "単位":
            if name == "プランク" || name == "バックプランク"{
                return "秒"
            }
            return "回"
        default :
            return "秒"
        }
    }
    
    func startQueuedUpdates() {
        // ジャイロセンサーが使えない場合はこの先の処理をしない
        guard motion.isDeviceMotionAvailable else { return }
        
        // 更新感覚
        motion.deviceMotionUpdateInterval = 6.0 / 60.0 // 0.1秒間隔
        
        // 加速度センサーを利用して値を取得する
        // 取ってくるdataの型はCMAcccerometterData?になっている
        motion.startDeviceMotionUpdates(to: queue) { data, error in
            // dataはオプショナル型なので、安全に取り出す
            if let validData = data {
                DispatchQueue.main.async {
                    self.x = validData.gravity.x
                    self.y = validData.gravity.y
                    self.z = validData.gravity.z
                }
            }
        }
    }
    
    func trainingMenu(name: String) {
        nowMenu = name
    }
    
    // トレーニング
    func training() {
        if nowSetCount < 1 {
            if self.nowMenu == "プランク" || self.nowMenu == "バックプランク" {
                nowTrainingCount = Double(trainingMaxCount[trainingIndex!].value)
            } else {
                nowTrainingCount = 1
            }
            nowSetCount = 1
        }
        
        
        trainingSucess = 0
        speeche(text: "スタート")
        startQueuedUpdates()
        speakTimes()
        trainingTime()
    }
    
    
    
    // センサーによるトレーニング
    func trainingTime() {
        if self.nowMenu == "プランク" || self.nowMenu == "バックプランク" {
            trainingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                
                
                print("print\(self.setMaxCount)")
                self.nowTrainingCount -= 1.0
                print("\(self.nowTrainingCount)")
                if self.nowTrainingCount <= 5.0 {
                    if !self.speechSynthesizer.isSpeaking {
                        self.speeche(text: String(Int(self.nowTrainingCount)))
                    }
                    if self.nowTrainingCount <= 0.0 {
                        self.trainingSucess = 2
                        if (self.setMaxCount[self.setIndex!].value <= self.nowSetCount) {
                            self.stopTraining()
                        } else {
                            self.pauseTraining()
                        }
                    }
                }
            }
        } else {
            trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                switch(self.sensorjudge){
                    
                case true:
                    if self.x >= 0.94 {
                        //現在の回数(init:0) > 設定回数(test:3)
                        if Int(self.nowTrainingCount) >= Int(self.trainingMaxCount[self.trainingIndex!].value) {
                            print("\(self.nowTrainingCount)       \(self.nowSetCount)")
                            //現在のセット数と設定セット数の比較
                            if self.nowSetCount >= self.setMaxCount[self.setIndex!].value {
                                
                                self.stopTraining()
                            } else {
                                self.trainingSucess = 2
                                self.speeche(text: "休憩してください")
                                
                                self.motion.stopDeviceMotionUpdates()
                                self.pauseTraining()
                            }
                        } else {
                        }
                    }
                    
                case false:
                    break
                    
                }
            }
        }
    }
    
    func pauseTraining() {
        if trainingSucess == 0 {
            self.speechSynthesizer.pauseSpeaking(at: .word)
            print("一時停止")
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "一時停止します")
            trainingSucess = 1
        } else if trainingSucess == 1 {
            self.speechSynthesizer.pauseSpeaking(at: .word)
            print("再開")
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "再開します")
            if !speechSynthesizer.isSpeaking {
                training()
                trainingSucess = 0
            }
        } else if trainingSucess == 2{
            self.motion.stopDeviceMotionUpdates()
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "第\(nowSetCount)セット終了")
            
            nowTrainingCount = Double(trainingMaxCount[trainingIndex!].value)
            nowSetCount += 1
            pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.interbalTime -= 1
                if self.interbalTime <= 5 {
                    self.speeche(text: String(self.interbalTime))
                    if self.interbalTime <= 0 {
                        self.pauseTimer?.invalidate()
                        self.interbalTime = 30
                        self.trainingSucess = 0
                        self.training()
                    }
                }
            }
        } else {
            
        }
    }
    
    // トレーニング終了
    func stopTraining() {
        // 終了
        trainingSucess = 3
        self.pauseTimer?.invalidate()
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        nowTrainingCount = Double(trainingMaxCount[trainingIndex!].value)
        nowSetCount = 1
        trainingFinish = true
        speechSynthesizer.pauseSpeaking(at: .word)
        speeche(text: "お疲れさまでした")
        print("終了")
    }
    
    // 音声作動範囲
    func speakTimes() {
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.nowMenu == "プランク" || self.nowMenu == "バックプランク" {
                if !self.speechSynthesizer.isSpeaking{
                    
                    
                    if self.x >= -0.08 {
                                            } else if self.x <= -0.12 {
                        // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                        self.adviceSensor(advice: "もう少し腰を上げましょう", sucess: "その位置です")
                    }
                }
            } else {
                switch(self.sensorjudge){
                    
                case true:
                    if self.x >= 0.96{
                        self.adviceSensor(advice: "あげてください", sucess: "")
                        self.sensorjudge = false
                        print("\(self.nowTrainingCount)")
                        print("\(self.trainingMaxCount[self.trainingIndex!].value)")
                        self.nowTrainingCount += 1.0
                    }
                    
                case false:
                    if self.x <= 0.04{
                        self.adviceSensor(advice: "さげてください", sucess: "")
                        self.sensorjudge = true
                        

                    }
                }
            }
        }
    }
    
    // 音声指導
    func adviceSensor(advice: String, sucess: String) {
        self.speakTimer?.invalidate()
        self.speeche(text: advice)
        self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if sucess.isEmpty {
                
               
                if !self.speechSynthesizer.isSpeaking{
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes()
                }
                
            } else {
                // 複数の値に対応できるようにする
                if self.x <= -0.08 && self.x >= -0.12 {
                    // 現在音声が動作中か
                    if self.speechSynthesizer.isSpeaking {
                        self.speechSynthesizer.pauseSpeaking(at: .word)
                    }
                    self.speeche(text: sucess)
                }
                if !self.speechSynthesizer.isSpeaking {
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes()
                }
            }
        }
    }
    
    // 自動音声機能
    func speeche(text: String) {
        
        // AVSpeechSynthesizerのインスタンス作成
        speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string: text) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP") // 言語
        utterance.rate = 0.5 // 読み上げ速度
        utterance.pitchMultiplier = 1.0 // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.0
        speechSynthesizer.speak(utterance)
    }
}
