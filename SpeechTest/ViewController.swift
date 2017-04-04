//
//  ViewController.swift
//  SpeechTest
//
//  Created by James Jongsurasithiwat on 4/1/17.
//  Copyright © 2017 James Jongs. All rights reserved.
//
import Speech
import UIKit
import AVKit

@IBDesignable
class SpeechViewController: UIViewController {

    // MARK: CONTANTS

    let busNumber = 0
    let bufferSize: UInt32 = 1024

    // MARK: VARIABLES

    var recordingStateIsOn: Bool = false

    @IBOutlet weak var textView: InterpretedTextView!

    @IBOutlet weak var recordButton: RecordButton!

    @IBAction func record(_ sender: Any) {
        if recordingStateIsOn {
            stopRecording()
            recordButton.setTitle("Record", for: .normal)
            recordButton.backgroundColor = UIColor.green
        } else {
            recordButton.setTitle("Stop", for: .normal)
            recordButton.backgroundColor = UIColor.red

            recordButton.setNeedsDisplay()
            do {
                textView.text = ""
                try startRecording()
            } catch {
                textView.text = "Error Recording"
            }
        }
        recordingStateIsOn = !recordingStateIsOn
    }

    @IBAction func recordAction(_ sender: UIButton) {

    }

    // MARK: - FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        askPermission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func askPermission() {
        SFSpeechRecognizer.requestAuthorization {(authStatus) in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    // Good to go
                    break
                case .denied:
                    // User said no
                    break
                case .restricted:
                    // Device isn't permitted
                    break
                case .notDetermined:
                    // Don't know yet
                    break
                }
            }
        }
    }

    private func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer() else {
            // Not supported for device's locale
            // Recognition not available
            return
        }

        guard recognizer.isAvailable else {
            // Not available right now
            // Internet connectivity not available
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request){ (result,error) in
            guard let result = result else {
                // Result is nil; handle error because recognition failed
                return
            }

            // The recognizer will call the completion handler multiple times
            // result.isFinal will be turned on when the final completion is called

            if result.isFinal {
                print("File said \(result.bestTranscription.formattedString)")
            }
        }
    }


    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask? = SFSpeechRecognitionTask()


    private func setupAudioEngine() {
        // Setup Audio Session
        let node = audioEngine.inputNode
        let recordingFormat = node?.outputFormat(forBus: busNumber)
        node?.installTap(onBus: busNumber, bufferSize: bufferSize, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
    }


    private func startRecording() throws {
        // Note it is ok to append buffer to recognition request both before and after it has started recognition
        setupAudioEngine()
        try audioEngine.start()
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
            (result,error) -> Void in
            guard let result = result else {
                self.textView.text = "Error in return from recognition task \(error)"
                return
            }

            // Clear the test
            self.textView.text = ""
            self.textView.text = "Best: \(result.bestTranscription.formattedString)"
            for (index,transcription) in result.transcriptions.enumerated() {
                self.textView.text.append("\n\(index): \(transcription.formattedString)")
            }
            if result.isFinal {
                self.textView.text.append("\nNo More Recognition")

                if self.recordingStateIsOn {
                    self.record(self.recordButton) // Turn off the record button
                }
            }
        }
    }


    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: busNumber)
        // Tell the request we have finished recording audio
        recognitionRequest.endAudio()
    }


    private func cancelRecording() {
        audioEngine.stop()
        // Ignore the results and free up resources used by speech recognition.
        recognitionTask?.cancel()
    }

    // Speech recognition is free, but not unlimted
    // There is a limit of 1 minute duration.
}










