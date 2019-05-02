//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Victor C. on 2/05/19.
//  Copyright © 2019 Victor C. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
//            detener la grabacion
            grabarAudio?.stop()
//            cambiar texto del boton grabar
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
        }else{
//            empezar a grabar
            grabarAudio?.record()
//            cambiar texto del boton grabar  detener
            grabarButton.setTitle("DETENER", for: .normal)
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch {}
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
       /* if grabarAudio!.isRecording{
//            detener la grabacion
            grabarAudio?.stop()
//            cambiar texto del boton grabar
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
        }else {
//            empezar a grabar
            grabarAudio?.record()
//            cambiar el texto del boton grabar a detener
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
        }*/
    }
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false
    }
    
    func configurarGrabacion(){
        do{
//              creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
//            creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
//            impresion de ruta donde se guarda los archivos
            print("*******************+*")
            print(audioURL!)
            print("*********************")
            
//            crear opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
//            crear objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

