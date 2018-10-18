//
//  MainViewViewController.swift
//  AudioProject
//
//  Created by 고상범 on 2018. 5. 14..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
//timer

class MainViewController:UIViewController, AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    static var player : AVAudioPlayer!
    var ViewCont : ViewController!
    
    var delegate : AVAudioPlayerDelegate?
    var timer : Timer!
    var durationOfMP3 : TimeInterval!
    var musicInfo = [MusicData]()
    var time : CMTime!
    var timeScale : Float!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var titleBottomBar: UILabel!
    @IBOutlet weak var artistBottombar: UILabel!
    
    
    
    //메인 뷰 쪽에서 플레이 버튼이 조정 가능하게 구현하려고 했으나 완성하지 못했습니다.
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            MainViewController.player?.play()
        } else {
            MainViewController.player?.pause()
        }
       /*
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
    */
    
    }
    
    func initializePlayer (){
        //다른 음악파일 정보를 가져다 쓰느라 DataAsset으로 파일을 불러오지 않고 초기화하는데에 사용하였습니다.
        guard let soundAsset : NSDataAsset = NSDataAsset(name : "sample1") else {
            print("File 을 가져올 수 없습니다.")
            return
        }
        do {
            try MainViewController.player = AVAudioPlayer(data : soundAsset.data)
         //  MainViewController.player.delegate = self
            
            
        } catch let error as NSError {
            print("player 초기화 실패")
            print("code : \(error.code), message : \(error.localizedDescription)")
        }
        
    
    } // static player가 play()되어 질 때 같이 사용해보려고 했으나 완성하지 못했습니다.
        /*func makeAndFireTimer(){
           self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self] (timer: Timer) in
                //if self.Slider.isTracking {return}
               // self.updateTimeLabelText(time: self.player.currentTime)
                //self.Slider.value = Float(self.player.currentTime)
            })
            MainViewController.timer.fire()
            
        }
        
        func invalidateTimer(){
            MainViewController.timer.invalidate()
            MainViewController.timer = nil
            
        }*/
        func addPlayPauseButton(){
            //let button: UIButton = UIButton(type: UIButtonType.custom)
            playPauseBtn.translatesAutoresizingMaskIntoConstraints = false
            
            //self.view.addSubview(button)
            
            
            playPauseBtn.setImage(UIImage(named:"newPlayBtn"), for: UIControlState.normal)
            playPauseBtn.setImage(UIImage(named:"newPauseBtn"),for: UIControlState.selected)
            
            playPauseBtn.addTarget(self, action: #selector(self.playButtonPressed(_:)),for: UIControlEvents.touchUpInside)
            
            
        }
    
    
    // MARK : -TableView
    // 실제 시장에 나와있는 플레이어 앱을 참고로 최대한 비슷하게 만들어보기위해서 테이블뷰를 사용하였습니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return musicInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MainTableViewCell
        cell.songTitle.text = musicInfo[indexPath.row].songTitle
        cell.songArtist.text = "- \(musicInfo[indexPath.row].songArtist)"
        cell.songImage.image = musicInfo[indexPath.row].songArtwork
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        initializePlayer()
        
        
        
        do{MainViewController.player.stop()
            
            
            let path = Bundle.main.path(forResource: musicInfo[indexPath.row].songTitle, ofType: ".mp3")
            
                
            try MainViewController.player = AVAudioPlayer(contentsOf:NSURL(fileURLWithPath: path!) as URL )
            MainViewController.player.delegate = self
            
            MainViewController.player.play()
            
        }
            
         catch{
            print("failed")
        }
            titleBottomBar.text = musicInfo[indexPath.row].songTitle
            artistBottombar.text = musicInfo[indexPath.row].songArtist
        
        
        }
    
    //디렉토리내에 있는 음악파일에 대한 정보를 가져오는 method입니다.
    //해당 mp3 파일의 앨범 자켓사진과 노래 제목 아티스트명을 가져오기 위해서 AVmetatdataItem을 이용하였습니다.
    //코드 참고 :https://stackoverflow.com/questions/30243658/displaying-artwork-for-mp3-file
    // CMTime 관련 애플 문서 참고하였습니다.
    func extractSongInfo(){

        guard let urlF = Bundle.main.urls(forResourcesWithExtension: ".mp3", subdirectory: "/") else {
            print("no value")
            return
        }
       
        for urlForData in urlF{
        let metaDataList = AVPlayerItem.init(url: urlForData ).asset.metadata as [AVMetadataItem]
            
            time = CMTimeMake(AVPlayerItem.init(url: urlForData ).asset.duration.value,AVPlayerItem.init(url: urlForData ).asset.duration.timescale )
            var musicData = MusicData.init(sTitle: "", sArtist: "", sArtwork: #imageLiteral(resourceName: "play"),sLength:0)
        
            musicData.timeSecond = time.seconds
             for ex in metaDataList{
               //print(ex.value)
                
                if(ex.commonKey?.rawValue == "artwork"){
                    
                    guard let image: UIImage = UIImage(data:ex.value as! Data,scale:1.0) else{
                        print("no artwork")
                        return
                    }
                    musicData.songArtwork = image
                    
                }
                else if(ex.commonKey?.rawValue == "title"){
                    let titleVal = ex.value
                    musicData.songTitle = (titleVal as! NSString) as String
                }
                else if(ex.commonKey?.rawValue == "artist"){
                    let artistVal = ex.value
                    musicData.songArtist = (artistVal as! NSString) as String
                }

                
            }
            musicInfo.append(musicData)
            
        }
        
    }
    
    //해당 테이블뷰를 클릭했을때 나오는 세그웨이로 연결된 뷰 객체 입니다 객체는 ViewController 클래스를 통해서 생성됩니다. 이 부분을 잘이해하지 못하여 한번 음악을 듣고 정지를 누르고 나오지 않으면 다음 음악을 들을때 앱이 종료되는 에러가 발생하였고 해결하지 못하였습니다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "musicDetails"{
        
            if let indexPath = tableView.indexPathForSelectedRow {
                ViewCont = segue.destination as! ViewController
                ViewCont.songTitle = musicInfo[indexPath.row].songTitle
                ViewCont.songArtist = musicInfo[indexPath.row].songArtist
                ViewCont.songArtwork = musicInfo[indexPath.row].songArtwork
                ViewCont.songLength = musicInfo[indexPath.row].timeSecond
              
                
                
            }
        
            ViewCont.delegateV = self
          
        }
    }
    //MARK: - MainView Delegate
    // 메인 뷰에서 player delegate 을 받아 ViewController 객체에 알려주기 위해서 작성해 보았습니다.
   func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    ViewCont.audioPlayerDidFinishPlaying(player, successfully: flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        ViewCont.audioPlayerDecodeErrorDidOccur(player, error: error)
    }
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
    
        addPlayPauseButton()
        extractSongInfo()
    }
    

}


