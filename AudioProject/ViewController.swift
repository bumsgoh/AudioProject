//
//  ViewController.swift
//  AudioProject
//
//  Created by 고상범 on 2018. 5. 9..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songArtworkLabel: UIImageView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer : Timer!
    var songTitle : String?
    var songArtist : String?
    var songArtwork : UIImage?
    var songLength : Double?
    var Main : MainViewController! = MainViewController()
    var delegateV : AVAudioPlayerDelegate!

    @IBAction func playBtnPressed(_ sender: UIButton) {

        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            MainViewController.player.play()
        } else {
            MainViewController.player.pause()
        }
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
    }
    
    @IBAction func fastBackward(_ sender: UIButton) {
        
        var time: TimeInterval = MainViewController.player.currentTime
        if(time > 1){
            time -= 1.0 }
        if (time <= 0)
        {   MainViewController.player.stop()
            self.playPauseBtn.isSelected = false
            self.Slider.value = 0
            self.updateTimeLabelText(time: 0)
           // self.invalidateTimer()
            
        }else
        {
           MainViewController.player.currentTime = time
        }
    }
    @IBAction func fastForward(_ sender: UIButton) {
        
        var time: TimeInterval = MainViewController.player.currentTime
        time += 1.0 // Go forward by 5 seconds
        if time > MainViewController.player.duration
        {   MainViewController.player.stop()
            self.playPauseBtn.isSelected = false
            self.Slider.value = 0
            self.updateTimeLabelText(time: 0)
        }else
        {
            MainViewController.player.currentTime = time
        }
    }
    
    func initializePlayer (){
      
        self.Slider.maximumValue = Float(songLength!)
        self.Slider.minimumValue = 0
        self.Slider.value = Float(MainViewController.player.currentTime)
        
    }
    
    func updateTimeLabelText(time : TimeInterval){
        let minute : Int = Int(time/60)
        let second : Int = Int(time.truncatingRemainder(dividingBy: 60))
        let miliSecond : Int = Int(time.truncatingRemainder(dividingBy: 1)*100)
        let timeText : String = String(format : "%02ld:%02ld:%02ld",minute,second,miliSecond)
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer(){ //이 함수 타이머 부분이 잘 이해가 안되어 테이블 뷰를 눌러 음악을 실행하고 Back 버튼으로 나간후 다시 다른 음악을 켰을 때 에러가 발생하였습니다. 여기에 대해서 MainViewController 안의 timer 변수를 static 으로 공유하면 어떨지 생각해 보았지만 답은 못 찾았습니다.
        self.timer =
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self] (timer: Timer) in
        if self.Slider.isTracking {return}
        self.updateTimeLabelText(time: MainViewController.player.currentTime)
        self.Slider.value = Float(MainViewController.player.currentTime)
            })
        self.timer.fire()
        
        }
    func invalidateTimer(){
       self.timer.invalidate()
        self.timer = nil
        
    }
    func addPlayPauseButton(){
        //let button: UIButton = UIButton(type: UIButtonType.custom)
        playPauseBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //self.view.addSubview(button)
        
        playPauseBtn.setImage(UIImage(named:"newPlayBtn"), for: UIControlState.normal)
        playPauseBtn.setImage(UIImage(named:"newPauseBtn"), for: UIControlState.selected)
        
        playPauseBtn.addTarget(self, action: #selector(self.playBtnPressed(_:)),for: UIControlEvents.touchUpInside)
            //self.player?.play()
      // self.playPauseBtn = button
    }
    
    func addTimeLabel(){
        //let timeLabel: UILabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(timeLabel)
        
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        //self.timeLabel = timeLabel
        self.updateTimeLabelText(time: 0)
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        
        if sender.isTracking {return}
        MainViewController.player.currentTime = TimeInterval(sender.value)
        
    }
    func addSlider(){
        //let slider: UISlider = UISlider()
        Slider.translatesAutoresizingMaskIntoConstraints = false
        
       // self.view.addSubview(slider)
        Slider.minimumTrackTintColor = UIColor.white
        
        Slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        //self.Slider = Slider
        
    }
    // MARK: - Delegate Methods
    //아래 method에서는 player 를 메인 뷰의 static 으로 정의하여 이곳에서 delegate 이 호출되어지지 않아 메인 뷰쪽에서 처리하였습니다.
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.playPauseBtn.isSelected = false
        self.Slider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
    func addViewsWithCode() {
        self.addPlayPauseButton()
        self.addTimeLabel()
        self.addSlider()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        addViewsWithCode()
        initializePlayer()
        songTitleLabel.text =  songTitle
        songArtistLabel.text = songArtist
        songArtworkLabel.image = songArtwork
        playBtnPressed(self.playPauseBtn)
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
    
    }


}

