//
//  FormatterService.swift
//  Running
//
//  Created by Maxime Maheo on 09/03/2022.
//

import Foundation

protocol FormatterServiceProtocol: AnyObject {
    func format(date: Date,
                dateStyle: DateFormatter.Style,
                timeStyle: DateFormatter.Style) -> String
    func format(value: Double,
                accuracy: Int) -> String
}

final class FormatterService: FormatterServiceProtocol {
    
    // MARK: - Properties
    
    private let formatDateFormatter = DateFormatter()
    
    private let calendar = Calendar.current

    // MARK: - Methods
    
    func format(date: Date,
                dateStyle: DateFormatter.Style,
                timeStyle: DateFormatter.Style) -> String {
        formatDateFormatter.dateStyle = dateStyle
        formatDateFormatter.timeStyle = timeStyle
        
        return formatDateFormatter.string(from: date)
    }
    
    func format(value: Double,
                accuracy: Int) -> String { String(format: "%.\(accuracy)f", value) }
}
