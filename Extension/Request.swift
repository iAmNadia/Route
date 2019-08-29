//
//  Request.swift
//  Route
//
//  Created by Надежда Морозова on 16/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//


import Alamofire
import RxSwift

// Расширения, чтобы внедрить код сразу в вызов Alamofire
extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    // Создаём свой аналог responseJSON, который будет возвращать Observable
    func responseJSON() -> Observable<Any> {
        // Создаем Observable
        return Observable.create { observer in
            // Используем реализацию из Alamofire, чтобы получить ответ
            let request = self.base.responseJSON { response in
                // Обрабатываем успешный ответ
                switch response.result {
                case .success(let value):
                    // Публикуем событие с данными сервера
                    observer.onNext(value)
                    // Публикуем событие о завершении последовательности
                    observer.onCompleted()
                    
                case .failure(let error):
                    // Если произошла ошибка, публикуем событие с ошибкой
                    observer.onError(error)
                }
            }
            // Создаём инструкцию, как завершать Observable
            return Disposables.create(with: request.cancel)
        }
    }
    
}

