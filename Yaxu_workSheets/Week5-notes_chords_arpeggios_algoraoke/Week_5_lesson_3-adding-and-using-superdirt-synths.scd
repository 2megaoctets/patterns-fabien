///////////////////////////////////////  Archetype SynthDef for SuperDirt

SynthDef(\archetypeSd, { // thanks to eris
 |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset,clamp=1|
 var line, env, volume, tone, outAudio;
 freq=freq*speed;
 line = Line.ar(begin,end,sustain/speed,doneAction: Done.freeSelf);
 env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
 volume = IEnvGen.ar(env, line);
 tone = (Pulse.ar(freq,line)+Pulse.ar(freq*1.01,line)+Pulse.ar(freq*0.99,line))/3;
 outAudio = RLPF.ar(tone*volume, 20000*clamp*volume,0.3);
 OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;

///////////////////////////////////////  Julian rohrhuber (SuperDirt developper)

/*The following concerns only synths that come from the tidal "sound" function
(not global effect synths like # delay, that are handled differently).

In superdirt, the freeing of synths is done by one internal synth that makes
the end of the chain of effects. It is the dirt_gate synth. Its definition is
in core-synths.scd. I posted it below [1]. It applies a minimal envelope to the
whole event (including all the effects you applied to it).
The doneAction: 14 is called after this envelope is completed.
By setting the fadeInTime and fadeTime parameters in tidal, you can harden
or soften the attack/decay.
This means that you can make SynthDefs with synths that do not release themselves,
something we normally avoid in supercollider, because you'd pile up synths endlessly.
But here, you could simply define a synth like this:
SynthDef(\mess, { |out| Out.ar(out, GrayNoise.ar) }).add
and you could play it in tidal with: sound "mess". The synths are freed by the dirt_gate synth.

1 . But usually, you want a synth to have a particular amplitude envelope.
Then you can define one in your SynthDef, see below [2].
Note that sustain means the duration of the whole
synth (this is what it is called in SuperCollider in general), which is sent
over from tidal (for setting it directly, try # sustain "0.1 0.3 0.5 1").
Then you can have a doneAction: 2 if you like (this will free the synth after the envelope is done),
but you can also leave this doneAction out altogether, because the synth is
freed externally anyhow.
For example:*/

SynthDef(\mess, { |out, sustain = 0.2| Out.ar(out, GrayNoise.ar * XLine.kr(1, 0.001, sustain)) }).add;

/*2 . But sometimes, you may want to use the synth outside superdirt, and then it is
polite that it cleans up after itself. Just make sure that you multiply your
envelope with the audible signal, otherwise you'll hear clicks at the end of
each synth.*/
SynthDef(\mess, { |out, sustain = 0.2| Out.ar(out, GrayNoise.ar * XLine.kr(1, 0.001, sustain, doneAction: 2)) }).add;

// [1]
SynthDef("dirt_gate" ++ numChannels, { |out, in, sustain = 1, fadeInTime = 0.001, fadeTime = 0.001, amp = 1|
		var signal = In.ar(in, numChannels);
		 //  doneAction: 14: free surrounding group and all nodes
		var env = EnvGen.ar(Env([0, 1, 1, 0], [fadeInTime, sustain, fadeTime], \sin), levelScale: amp, doneAction: 14);
		signal = signal * env * DirtGateCutGroup.ar(fadeTime, doneAction: 14);
		OffsetOut.ar(out, signal);
		ReplaceOut.ar(in, Silent.ar(numChannels)) // clears bus signal for subsequent synths
	}, [\ir, \ir, \ir, \ir, \ir, \ir]).add;

// [2]
SynthDef(\imp, { |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset|
	var env, sound, rate, phase;
	env = EnvGen.ar(Env.perc(0.01, 0.99, 1, -1), timeScale:sustain, doneAction:2);
	phase = Line.kr(begin, end, sustain);
	rate = (begin + 1) * (speed + Sweep.kr(1, accelerate));
	sound = Blip.ar(rate.linexp(0, 1, 1, freq) * [1, 1.25, 1.51, 1.42], ExpRand(80, 118) * phase).sum;
	OffsetOut.ar(out,
		DirtPan.ar(sound, ~dirt.numChannels, pan, env)
	)
}).add;
