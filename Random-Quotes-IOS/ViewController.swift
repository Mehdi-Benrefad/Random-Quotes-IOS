//
//  ViewController.swift
//  Random-Quotes-IOS
//
//  Created by Mehdi Benrefad on 14/04/2021.
//  Copyright © 2021 Mehdi Benrefad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

     //action sur le bouton new Quote
    @IBAction func tappedNewQuoteButton() {
        //on fait appel a la methode statique getQuote en lui passant une fonction callback en parametres
         QuoteService.getQuote { (success, quote) in
             //si la requette est reussie o affiche la citation
               if success, let quote = quote {
                   self.update(quote: quote)
               } else {// si la requette echoue on affiche une alerte d'erreur
                self.presentAlert()
               }
           }
    }
    
    
    
    private func update(quote: Quote) {
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
        imageView.image = UIImage(data: quote.imageData)
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

