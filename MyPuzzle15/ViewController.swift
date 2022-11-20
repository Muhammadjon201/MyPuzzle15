//
//  ViewController.swift
//  MyPuzzle15
//
//  Created by ericzero on 11/13/22.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let myRecordKey = "myRecordKey"

    lazy var containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            return view
        }()
        lazy var stepsLabel: UILabel = {
            let view = UILabel()
            view.backgroundColor = .clear
            view.font = .systemFont(ofSize: 24, weight: .semibold)
            view.textAlignment = .center
            view.textColor = .systemOrange
            view.text = "Your steps: \(stepCount)!"
            return view
        }()
        
        let wd = UIScreen.main.bounds.width
        let mg: CGFloat = 15
        let dis: CGFloat = 5
        lazy var bs = (wd-2*mg-3*dis)/4
        
        var stepCount = 0 {
            didSet {
                stepsLabel.text = "Your steps: \(stepCount)!"
            }
        }
            
        var undoArr = [Int]()
        var redoArr = [Int]()
       // var recodsArr = [134, 198, 247]
        

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
           
        
            view.addSubview(containerView)
            view.addSubview(stepsLabel)
            
            createTopBtns()
            makeButtons()
            
            stepsLabel.snp.makeConstraints { make in
                make.bottom.equalTo(containerView.snp.top).offset(-20)
                make.left.equalTo(mg)
                make.right.equalTo(-mg)
            }
            containerView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(mg)
                make.right.equalTo(-mg)
                make.height.equalTo(containerView.snp.width)
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
        
        func createTopBtns() {
            let imgArr = ["list", "undo", "redo", "restart"]
            let ts = bs/2
            for i in 0...3 {
                let btn = UIButton()
                btn.frame = CGRect(x: 2*mg+(ts+(wd-4*ts-4*mg)/3)*CGFloat(i), y: 4*mg, width: ts, height: ts)
                btn.titleLabel?.font = .systemFont(ofSize: 40, weight: .semibold)
                btn.setTitleColor(.black, for: .normal)
                btn.backgroundColor = .clear
                btn.clipsToBounds = true
                btn.setImage(UIImage(named: imgArr[i])?.withTintColor(.systemOrange), for: .normal)
                view.addSubview(btn)
                btn.tag = 20+i
            }
            
            (view.viewWithTag(20) as? UIButton)?.addTarget(self, action: #selector(recordsClicked), for: .touchUpInside)
            (view.viewWithTag(21) as? UIButton)?.addTarget(self, action: #selector(undoClicked), for: .touchUpInside)
            (view.viewWithTag(22) as? UIButton)?.addTarget(self, action: #selector(redoClicked), for: .touchUpInside)
            (view.viewWithTag(23) as? UIButton)?.addTarget(self, action: #selector(restart), for: .touchUpInside)
            
        }
        
        func makeButtons() {
            var numArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", ""]
    //        numArr = numArr.shuffled()
            numArr.append("15")
//            numArr.shuffle()
            var k = 0
            for i in 0...3 {
                for j in 0...3 {
                    let btn = UIButton()
                    btn.frame = CGRect(x: (bs+dis)*CGFloat(j), y: (bs+dis)*CGFloat(i), width: bs, height: bs)
                    btn.titleLabel?.font = .systemFont(ofSize: 40, weight: .semibold)
                    btn.setTitleColor(.white, for: .normal)
                    
                    btn.layer.cornerRadius = 12
                    btn.clipsToBounds = true
                    let str = numArr[k]
                    btn.setTitle(str, for: .normal)
                    if str == "" {
                        btn.tag = 16
                    } else {
                        btn.tag = Int(str) ?? 0
                    }
                    btn.backgroundColor = btn.tag == 16 ? .clear : .systemOrange
                    containerView.addSubview(btn)
                    
                    btn.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
                    k += 1
                }
            }
        }

        @objc func tapBtn(_ sender: UIButton) {
            guard let emptyBtn = (containerView.viewWithTag(16) as? UIButton) else { return }
            let tappedBtn = sender
            let emptyCenter = emptyBtn.center
            let tappedCenter = tappedBtn.center
            
            if abs(emptyCenter.x-tappedCenter.x) == bs+dis && abs(emptyCenter.y-tappedCenter.y) != bs+dis || abs(emptyCenter.x-tappedCenter.x) != bs+dis && abs(emptyCenter.y-tappedCenter.y) == bs+dis &&  abs(emptyCenter.x-tappedCenter.x) != 2*dis &&  abs(emptyCenter.y-tappedCenter.y) != 2*dis {
                UIView.animate(withDuration: 0.4) {
                    emptyBtn.center = tappedCenter
                    tappedBtn.center = emptyCenter
                }
                stepCount += 1
                undoArr.append(sender.tag)

                if isWinner() == true {
                    youWin()
                }
            }
            
        }
        
        
        func isWinner() -> Bool{
            guard let emptyBtn = (containerView.viewWithTag(16) as? UIButton) else { return false }
            if emptyBtn.center.x == (bs+dis)*CGFloat(3)+bs/2 && emptyBtn.center.y == (bs+dis)*CGFloat(3)+bs/2 {
                var k = 1
                var n = 0
                for i in 0...3 {
                    for j in 0...3{
                        guard let checkBtn = (containerView.viewWithTag(k) as? UIButton) else { return false }
                        if checkBtn.center.x == (bs+dis)*CGFloat(j)+bs/2 && checkBtn.center.y == (bs+dis)*CGFloat(i)+bs/2 {
                            n += 1
                            if n == 16 {
                                return true
                            }
                        }
                        k += 1
                    }
                }
            }
            return false
        }
        
        func youWin() {
            let alert = UIAlertController(title: "You Win!", message: "Congritulations! You Winner! Your steps: \(stepCount)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "RESTART", style: .default, handler: { _ in
                self.restart(UIButton())
            }))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(alert, animated: true)
                self.getSetRecArr()
            }
            
        }
        
        @objc func restart(_ sender: UIButton) {
            for i in 1...16 {
                guard let btn = containerView.viewWithTag(i) as? UIButton else { return }
                btn.removeFromSuperview()
            }
            stepCount = 0
            makeButtons()
        }
        
        @objc func undoClicked(_ sender: UIButton) {
            guard let tag = undoArr.last else { return }
            guard let emptyBtn = (containerView.viewWithTag(16) as? UIButton) else { return }
            guard let tappedBtn = (containerView.viewWithTag(tag) as? UIButton) else { return }
            let emptyCenter = emptyBtn.center
            let tappedCenter = tappedBtn.center
            UIView.animate(withDuration: 0.4) {
                emptyBtn.center = tappedCenter
                tappedBtn.center = emptyCenter
            }
            stepCount -= 1
            redoArr.append(tag)
            undoArr.removeLast()
        }
        @objc func redoClicked(_ sender: UIButton) {
            guard let tag = redoArr.last else { return }
            guard let emptyBtn = (containerView.viewWithTag(16) as? UIButton) else { return }
            guard let tappedBtn = (containerView.viewWithTag(tag) as? UIButton) else { return }
            let emptyCenter = emptyBtn.center
            let tappedCenter = tappedBtn.center
            UIView.animate(withDuration: 0.4) {
                emptyBtn.center = tappedCenter
                tappedBtn.center = emptyCenter
            }
            stepCount += 1
            undoArr.append(tag)
            redoArr.removeLast()
        }
        @objc func recordsClicked(_ sender: UIButton) {
            let arr = defaults.array(forKey: myRecordKey) as? [Int] ?? [Int]()
            let vc = RecordListVC()
            vc.recordsArr = arr.sorted()
            navigationController?.pushViewController(vc, animated: true)
        }
    
    func getSetRecArr() {
        var arr = defaults.array(forKey: myRecordKey) as? [Int] ?? [Int]()
        if arr.count < 10 {
            arr.append(stepCount)
        } else {
            arr = arr.sorted()
            if (arr.last ?? 0) > stepCount {
                arr.removeLast()
                arr.append(stepCount)
            }
        }
        defaults.set(arr, forKey: myRecordKey)
    }

}

