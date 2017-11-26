//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Rathod, Kinjal on 11/25/17.
//  Copyright © 2017 Rathod, Kinjal. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }

    func setupRecorder() {
        do {
        // Create an audio session
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.overrideOutputAudioPort(.speaker)
        try session.setActive(true)
        
        // Create URL for the audio file
        let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let pathComponents = [basePath, "audio.m4a"]
        audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
        print("####################")
        print(audioURL!)
        print("####################")

            
        // Create Settings for the audio recorder
        var settings : [String: AnyObject] = [:]
        settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
        // Create Audio recorder object
        audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
        audioRecorder!.prepareToRecord()
            
        } catch let error  as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            // Stop the recording
            audioRecorder?.stop()
            // Change button Title to record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true

        } else {
            // Start the recording
            audioRecorder?.record()
            // Change the button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
        audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {
            
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    navigationController?.popViewController(animated: true)
    }
}
