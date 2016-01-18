//
//  ViewController.swift
//  PeticionJSON
//
//  Created by Jose Navarro Alabarta on 18/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

/*
En este entregable desarrollarás una aplicación usando Xcode que después de haber realizado una petición a https://openlibrary.org/ (entregable anterior) analice os datos JSON obtenidos y los presente de manera adecuada

Para ello deberás crear una interfaz de usuario, usando la herramienta Storyboard que contenga:

1. Una caja de texto para capturar el ISBN del libro a buscar

2. EL botón de "enter" del teclado del dispositivo deberá ser del tipo de búsqueda ("Search")

3. El botón de limpiar ("clear") deberá estar siempre presente

4. En la vista deberás poner elementos para mostrar:

El título del libro
Los autores (recuerda que está en plural, pueden ser varios)
La portada del libro (en caso de que exista)
Un ejemplo de URL para acceder a un libro es:

https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7

Su programa deberá sustituir el último código de la URL anterior (en este caso 978-84-376-0494-7) por lo que se ponga en la caja de texto

Al momento de presionar buscar en el teclado, la vista deberá mostrar los datos anteriormente descritos en concordancia con el ISBN que se ingreso en la caja de texto

En caso de error (problemas con Internet), se deberá mostrar una alerta indicando esta situación

Sube tu solución a GitHub e ingresa la URL en el campo correspondiente
*/

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var cISBN: UITextField!
    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var portada: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(cISBN: UITextField) -> Bool {
        
        cISBN.resignFirstResponder()
        asincrono(cISBN.text!)
        return true
    }
    
    func asincrono(isbn: String){
        //bloque no bloqueante
        let link = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: link) // conversion de la string a formato url
        let datos = NSData(contentsOfURL: url!) // se realiza la peticion al servidor
        
        
        
        
        if datos != nil {
            //revisar
            do{
                //bloqye de codigo
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                
                let isb = "ISBN:\(isbn)"
                
                let dico1 = json as! NSDictionary
                
                if (dico1.count > 0) {
                    
                    let dico2 = dico1.valueForKey(isb) as! NSDictionary

                    self.titulo.text =  dico2.valueForKey("title") as! NSString as String

            
                    //imagen
                    if (dico2["cover"] != nil ) {
                        let dico3 = dico2.valueForKey("cover") as! NSDictionary
                        let rutaImagen = dico3.valueForKey("small") as! NSString as String
                        let urlImagen :NSURL = NSURL(string: rutaImagen)!
                        let dataImage:NSData = NSData(contentsOfURL:urlImagen)!
                        portada.image = UIImage(data: dataImage)
                    }
                    
                    //autores
                    var dico4 = dico2.valueForKey("authors") as! [NSDictionary]
                    self.autores.text = dico4.removeAtIndex(0).valueForKey("name")! as! String
                }else{
                    
                    let alertController = UIAlertController(title: "Error", message: "ISBN introduccido no existe.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            catch _ {
                //no se captura nada
            }
        }else {
            let alertController = UIAlertController(title: "Error", message: "Ha habido un problema conectando con el servidor. Revisa tu conexión a internet y vuelve a intentarlo.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }


}

