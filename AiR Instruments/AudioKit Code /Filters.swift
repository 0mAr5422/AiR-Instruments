//
//  Filters.swift
//  AiR Instruments
//
//  Created by omar on 9/24/18.
//  Copyright © 2018 omar. All rights reserved.
//


import Foundation
import AudioKit

class Filter {
    
    var lpf: AKLowPassFilter?
    var bpf: AKBandPassButterworthFilter?
    var hpf: AKHighPassFilter?
    var frequency = 0.0
    var resonance = -20.0
    
    init(){
    }
    
    func getLPF(_ osc: AKOscillatorBank?, at freq: Double, resonance: Double) -> AKLowPassFilter {
        let lpf = AKLowPassFilter(osc, cutoffFrequency: freq, resonance: resonance)
        lpf.start()
        return lpf
    }
    
    func getHPF(_ osc: AKOscillatorBank?, at freq: Double, resonance: Double) -> AKHighPassFilter {
        let hpf = AKHighPassFilter(osc, cutoffFrequency: freq, resonance: resonance)
        hpf.start()
        return hpf
    }
    
    func getBPF(_ osc: AKOscillatorBank?, at freq: Double, resonance: Double) -> AKBandPassButterworthFilter {
        let bpf = AKBandPassButterworthFilter(osc, centerFrequency: freq, bandwidth: resonance)
        bpf.start()
        return bpf
    }
}

extension AKLowPassFilter {
    func setFrequency(to frequency: Double) {
        cutoffFrequency = frequency
    }
    
    func setResonance(to frequency: Double) {
        resonance = frequency
    }
}

extension AKBandPassButterworthFilter {
    func setFrequency(to frequency: Double) {
        centerFrequency = frequency
    }
    
    func setResonance(to frequency: Double) {
        bandwidth = frequency
    }
}

extension AKHighPassFilter {
    func setFrequency(to frequency: Double) {
        cutoffFrequency = frequency
    }
    
    func setResonance(to frequency: Double) {
        resonance = frequency
    }
}

extension Filter {
    func setFilterFreq(to freq: Double) {
        frequency = freq
    }
    
    func setFilterRes(to freq: Double) {
        resonance = freq
    }
}


