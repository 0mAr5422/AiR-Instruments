//
//  SynthModel.swift
//  AiR Instruments
//
//  Created by omar on 9/24/18.
//  Copyright © 2018 omar. All rights reserved.
//


// i made a change in line 23 changed the value of the decay from 0.2 to 0.002 ;

import Foundation
import AudioKit

protocol SynthModelDelegate {
    func didHitKey(_ synthModel: SynthModel, at index: Int)
    func didStopKey(_ synthModel: SynthModel, at index: Int)
}

class SynthModel {
    
    var attackValue = 0.7
    var decayValue = 0.002
    var sustainValue = 0.4
    var releaseValue = 0.5
    var filterFrequency = 2000.0
    var resFreq = -20.0
    var amp = 127
    var typeSelection = 0
    var filter = Filter()
    var osc: AKOscillatorBank?
    var filterMixer = AKMixer()
    var lpf = AKLowPassFilter()
    var bpf = AKBandPassButterworthFilter()
    var hpf = AKHighPassFilter()
    
    init() {
        osc = AKOscillatorBank(waveform: AKTable(.sawtooth))
        osc?.attackDuration = attackValue
        osc?.decayDuration = decayValue
        osc?.sustainLevel = sustainValue
        osc?.releaseDuration = releaseValue
        
        switch typeSelection {
        case 0:
           print(typeSelection)
           
            lpf = filter.getLPF(osc!, at: filterFrequency, resonance: resFreq)
            filterMixer.connect(input: lpf)
           AudioKit.output = filterMixer

        case 1:
            print(typeSelection)
            bpf = filter.getBPF(osc!, at: filterFrequency, resonance: resFreq)
            filterMixer.connect(input: bpf)
            AudioKit.output = filterMixer

        case 2:
            print(typeSelection)
            hpf = filter.getHPF(osc!, at: filterFrequency, resonance: resFreq)
            filterMixer.connect(input: hpf)
            AudioKit.output = filterMixer

        default:
            print(typeSelection)
            lpf = filter.getLPF(osc!, at: filterFrequency, resonance: resFreq)
            filterMixer.connect(input: lpf)
            lpf.bypass()
            AudioKit.output = filterMixer

        }
        
        do {
            try AudioKit.start()
        } catch  {
            print("error ")
        }
        
    }
    
    func playKey(noteNum: Double) {
        lpf.setFrequency(to: filterFrequency)
        bpf.setFrequency(to: filterFrequency)
        hpf.setFrequency(to: filterFrequency)
        lpf.setResonance(to: resFreq)
        bpf.setResonance(to: resFreq)
        hpf.setResonance(to: resFreq)
        osc?.attackDuration = attackValue
        osc?.decayDuration = decayValue
        osc?.sustainLevel = sustainValue
        osc?.releaseDuration = releaseValue
        osc?.play(noteNumber: MIDINoteNumber(noteNum), velocity: MIDIVelocity(amp))
    }
    
    func stopKey(noteNum: Int) {
        osc?.stop(noteNumber: MIDINoteNumber(noteNum))
    }
}
