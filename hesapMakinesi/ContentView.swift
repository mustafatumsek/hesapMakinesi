//  ContentView.swift
//  hesapMakinesi
//
//  Created by Mustafa Tümsek on 21.01.2025.
//

import SwiftUI

struct ContentView: View {

    let butonlar = [
        ["AC", "⌦", "%", "+"],
        ["1", "2", "3", "-"],
        ["4", "5", "6", "X"],
        ["7", "8", "9", "/"],
        [".", "0", "☀️", "="]
    ]

    let isaretler: [String] = ["+", "%", "X", "/"]

    @State var islemler = ""
    @State var sonuclar = ""
    @State var uyari = false
    @State var isDarkMode = true

    var body: some View {
        ZStack {
            (isDarkMode ? Color.black : Color.white)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Text(islemler)
                        .padding()
                        .foregroundColor(isDarkMode ? .white : .black)
                        .font(.system(size: 30, weight: .heavy))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack {
                    Spacer()
                    Text(sonuclar)
                        .padding()
                        .foregroundColor(isDarkMode ? .white : .black)
                        .font(.system(size: 50, weight: .heavy))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ForEach(butonlar, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { cell in
                            Button(action: { buttonPressed(cell: cell) }, label: {
                                Text(cell)
                                    .foregroundColor(renk(cell))
                                    .font(.system(size: 40, weight: .heavy))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            })
                        }
                    }
                }
            }
            .background(isDarkMode ? Color.black : Color.white)
            .alert(isPresented: $uyari) {
                Alert(
                    title: Text("Hata! Lütfen geçerli bir işlem giriniz."),
                    message: Text(islemler),
                    dismissButton: .default(Text("Tamam"))
                )
            }
            .padding()
        }
    }

    func renk(_ cell: String) -> Color {
        if cell == "AC" || cell == "⌦" {
            return .pink
        }
        if cell == "-" || cell == "=" || isaretler.contains(cell) {
            return .mint
        }
        return isDarkMode ? .white : .black
    }

    func buttonPressed(cell: String) {
        switch cell {
        case "AC":
            islemler = ""
            sonuclar = ""
        case "⌦":
            islemler = String(islemler.dropLast())
        case "=":
            sonuclar = hesapla()
        case "-":
            addMinus()
        case "X", "/", "%", "+":
            addOperator(cell)
        case "☀️": // Tema değiştirme işlemi
            isDarkMode.toggle()
        default:
            islemler += cell
        }
    }

    func addOperator(_ cell: String) {
        if !islemler.isEmpty {
            let last = String(islemler.last!)
            if isaretler.contains(last) {
                islemler.removeLast()
            }
            islemler += cell
        }
    }

    func addMinus() {
        if islemler.isEmpty || islemler.last! != "-" {
            islemler += "-"
        }
    }

    func hesapla() -> String {
        if validInput() {
            var islem = islemler.replacingOccurrences(of: "%", with: "*0.01")
            islem = islem.replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: islem)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatResult(val: result)
        }
        uyari = true
        return ""
    }

    func validInput() -> Bool {
        if islemler.isEmpty {
            return false
        }
        let last = String(islemler.last!)
        if isaretler.contains(last) || last == "-" {
            if last != "%" || islemler.count == 1 {
                return false
            }
        }
        return true
    }

    func formatResult(val: Double) -> String {
        if val.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", val)
        }
        return String(format: "%.2f", val)
    }
}

#Preview {
    ContentView()
}
