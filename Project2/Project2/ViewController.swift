import UIKit

final class AppLogic {
    
    // Immutable
    private let maximumNumberOfTries: Int
    private let answerArrayList: Array<String>
    private let numberOfInstruments: Int
    
    // Mutable
    private var currentQuestion: Int
    private var correctAnswered: Int
    private var currentNumberOfTries: Int
    
    
    public init() {
        self.maximumNumberOfTries = 3
        self.currentQuestion = 0
        self.correctAnswered = 0
        self.currentNumberOfTries = 0
        self.answerArrayList = ["accordion", "keyboard", "drum", "guitar", "clarinet", "piano", "saxophone", "bongos", "trumpet", "maracas", "trombone", "tambourine", "triangle", "banjo", "cello", "flute", "violin", "recorder", "harp", "xylophone"]
        self.numberOfInstruments = answerArrayList.count
    }
    
    // String func
    
    public func getImagePath() -> String {
        return "instrumentsImg/\(answerArrayList[self.currentQuestion]).jpg"
    }
    
    public func getNQuestion() -> String {
        return "Question \(String(self.currentQuestion + 1))/\(String(self.numberOfInstruments))"
    }
    
    public func getNumberOfTries() -> String {
        return "Number of Tries: \(String(self.maximumNumberOfTries - self.currentNumberOfTries))"
    }
    
    public func getCurrentCorrectAnswer() -> String {
        return self.answerArrayList[self.currentQuestion]
    }
    
    // Int func
    
    public func getCurrentNumberOfTries() -> Int {
        return self.currentNumberOfTries
    }
    
    public func getMaxTries() -> Int {
        return self.maximumNumberOfTries
    }
    
    public func getCurrentQuestion() -> Int {
        return self.currentQuestion
    }
    
    public func getNumberOfInstruments() -> Int {
        return self.numberOfInstruments
    }
    
    public func getNumberOfCorrectAnswer() -> Int {
        return self.correctAnswered
    }
    
    // Void
    
    public func incrementCorrectedAnswer() -> Void {
        self.correctAnswered += 1
    }
    
    public func incrementCurrentQuestion() -> Void {
        self.currentQuestion += 1
    }
    
    public func incrementNumberOfTries() -> Void {
        self.currentNumberOfTries += 1
    }
    
    public func resetNumberOfTries() -> Void {
        self.currentNumberOfTries = 0
    }
}

final class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nQuestionLabel: UILabel!
    @IBOutlet weak var musicInstrumentImg: UIImageView!
    @IBOutlet weak var numberOfTriesLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var checkAnsBtn: UIButton!
    
    //constants
    private let appLogic = AppLogic()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackLabel.isHidden = true
        nxtBtn.isHidden = true
        answerTextField.delegate = self
        nQuestionLabel.text = appLogic.getNQuestion()
        numberOfTriesLabel.text = appLogic.getNumberOfTries()
        musicInstrumentImg.image = UIImage(named: appLogic.getImagePath())
        
        nxtBtn.setTitle("Next Instrument", for: .normal)
        checkAnsBtn.setTitle("Check Answer", for: .normal)
    }
    
    private func setPropertiesOfFeedbackLabel(isRed: Bool, text: String) -> Void {
        feedbackLabel.isHidden = false
        feedbackLabel.textColor = isRed ? UIColor.red :  UIColor.green
        feedbackLabel.text = text
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        let answer = answerTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (appLogic.getCurrentNumberOfTries() < appLogic.getMaxTries()) {
            
            if (answer == appLogic.getCurrentCorrectAnswer()) {
                
                self.setPropertiesOfFeedbackLabel(isRed: false, text: "Hooray! You get the correct answer!")
                
                nxtBtn.isHidden = false
                answerTextField.isUserInteractionEnabled = false
                appLogic.incrementCorrectedAnswer()
            } else {
                
                self.setPropertiesOfFeedbackLabel(isRed: true, text: "Answer entered is Wrong!")
                
                appLogic.incrementNumberOfTries()
                numberOfTriesLabel.text = appLogic.getNumberOfTries()
                answerTextField.text = nil
                
            }
            
        }
        
        if (appLogic.getCurrentNumberOfTries() == appLogic.getMaxTries()) {
            nxtBtn.isHidden = false
            
            self.setPropertiesOfFeedbackLabel(isRed: true, text: "You had used up the tries for this question!")
            
            answerTextField.textColor = UIColor.red
            answerTextField.text = "The Correct Answer is: \(appLogic.getCurrentCorrectAnswer())"
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if (appLogic.getCurrentQuestion() < appLogic.getNumberOfInstruments() - 1) {
            
            feedbackLabel.isHidden = true
            nxtBtn.isHidden = true
            answerTextField.isUserInteractionEnabled = true
            
            appLogic.incrementCurrentQuestion()
            nQuestionLabel.text = appLogic.getNQuestion()
            appLogic.resetNumberOfTries()
            numberOfTriesLabel.text = appLogic.getNumberOfTries()
            answerTextField.text = nil
            answerTextField.textColor = UIColor.black
            musicInstrumentImg.image = UIImage(named: appLogic.getImagePath())
            
        } else {
            
            let alertController = UIAlertController(title: "Quiz is completed!", message: "Congratulations! Your score is \(appLogic.getNumberOfCorrectAnswer())/\(appLogic.getNumberOfInstruments())", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
