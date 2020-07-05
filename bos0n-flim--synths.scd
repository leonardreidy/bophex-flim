/*
  Project: Aphex Flim Generator
  File: rukano-flim--synths.scd
  Author: Rukano
  Source: https://github.com/rukano/scprivatepool/tree/master/projects/aphex_flim/
  Docs: [
    http://supercollider.sourceforge.net/wiki/index.php/User_FAQ
  ]
  Description: This file contains definition and initialization for UGENS (unit generators) that represent
  synthesisers, fx units, and song patterns. This file must be executed before the file that
  contains the definition and initializion of the general user interface (widget) for controlling
  the song's performance. See the comments below for steps to be taken to execute the code and
  for helpful comments on the code in this file.

  Note that the essential code in this file remains unchanged from Rukano's original source code
  at present. I have added comments to clarify the part played by each section of code, and I
  expect future versions of the code to change substantially. But for now there is considerable
  value to be garnered from analysis and experimentation with Rukano's source.

  The file contains the following changes:

    - added server options config
    - added server reboot command
    - added comments to clarify
*/

  // If you encounter errors executing the code block enclosed in parenthesis below, run the
  // the following two lines of code and wait until the server reboots. It should not be
  // necessary to run this code more than once per session, although it may be occasionally
  // necessary to kill the servers and call Server.local.reboot. According to some sources,
  // this can be set in the startup file [startup.scd]. But I have not been successful in
  // using it this way.
  // See the FAQ at the link at the top of this file for more information.

  /* -------------------------------------------------------------------------------------- */
  /* [SERVER OPTIONS] Configure memory size and reboot server                               */
  /* ---------------------------------------------------------------------------------------*/
  // Increase the memory size of the server to 4 times the default, adjust if necessary.
  // Execute these two lines before executing the code block below if memory allocation
  // errors occur.
  Server.local.options.memSize = Server.local.options.memSize * 4;
  Server.local.reboot;

(
  // To execute all code in this file, left click on the space after the parenthesis
  // above, release click, then hold down Ctrl (Cmd in MacOS) and press Enter


  /* -------------------------------------------------------------------------------------- */
  /* [INITIALIZATION] Initialize variables to store references to synths/fx/patterns        */
  /* ---------------------------------------------------------------------------------------*/
  q = q ? ();
  q.fx = ();
  q.ping = ();
  q.pong = ();
  q.chord = ();
  q.chords = ();
  q.buttons = ();

  /* -------------------------------------------------------------------------------------- */
  /* Define Ping synth                                                                      */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\ping, { |out, freq=440, attack=0.001, release=1, amp=0.1, pan|
	var snd;
	snd = FSinOsc.ar(freq);
	snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -20), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Peng synth                                                                      */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\peng, { |out, freq=440, attack=0.0001, release=1, amp=0.1, pan, modFreq=111, detune=2, rq=0.8|
	var snd, mod;
	mod = SinOsc.ar(modFreq);
	snd = Saw.ar([freq, freq*Rand(1.45, 1.55)] + modFreq.range(detune.neg, detune)).sum;
	snd = snd * mod;
	snd = RHPF.ar(snd, freq/2, rq*2);
	snd = RLPF.ar(snd, freq*2, rq/2);
	snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -12), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Chord synth                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\chord, { |out, freq=440, attack=0.2, sustain=0.2, decay=0.15, amp=0.05, pan, rq=0.25, gate=1|
	var snd;
	snd = Pulse.ar(freq + SinOsc.ar([Rand(0.8, 1.2), Rand(0.8, 1.2)]).range(-1,1), Rand(0.1, 0.49));
	snd = snd * SinOsc.ar(Rand(6.0, 8.2)).range(0.8, 1.0);
	snd = RLPF.ar(snd, freq, rq/4, 0.1);
	snd = snd + RHPF.ar(snd, freq, rq*2, 0.075);
	snd = snd + Blip.ar(freq, 3, 0.05);
	snd = snd * EnvGen.ar(Env.perc(attack, sustain), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp * 2);
	OffsetOut.ar(0, snd * amp / 2);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Pong synth                                                                      */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\pong, { |out, freq=440, attack=0.1, sustain=1, amp=0.1, pan|
	var snd;
	snd = Pulse.ar(freq, 0.1);
	snd = LPF.ar(snd, freq*4);
	snd = snd * 0.25 + RLPF.ar(snd, freq, 0.45);
	snd = snd + RLPF.ar(snd, freq*1.5, 0.1);
	snd = snd * EnvGen.ar(Env.perc(attack, sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Kick drum synth                                                                 */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\kick, { |out, ffreq=80, attack=0, release=2, amp=0.1, pan|
	var snd;
	snd = SinOsc.ar([ffreq, ffreq*1.01, ffreq*1.03, ffreq*1.06, ffreq*1.1], 0, 0.5).sum;
	snd = snd + PinkNoise.ar;
	snd = RLPF.ar(snd, ffreq, 0.1);
	snd = RLPF.ar(snd, ffreq*2, 0.2);
	snd = RLPF.ar(snd, ffreq*3, 0.3);
	snd = RLPF.ar(snd, ffreq*4, 0.4);
	snd = RLPF.ar(snd, ffreq*5, 0.5);
	snd = snd + LPF.ar(WhiteNoise.ar, ffreq*6);
	snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -50), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Bass synth                                                                      */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\bass, { |out, freq=100, attack=0.1, release=2, amp=0.1, pan|
	var snd;
	snd = SinOsc.ar(XLine.kr(
		[freq, freq*1.5, freq*2, freq*3],
		[freq, freq*1.5, freq*2, freq*3]/4,
		release/2,
		0,
		0.5)
	).sum;
	snd = RLPF.ar(snd, freq*2/3, 0.1);
	snd = snd * EnvGen.ar(Env.perc(attack, release, 2, -10), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Snare synth                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\snare, { |out, ffreq=100, rq=0.5, attack=0, release=0.5, amp=0.1, pan|
	var snd;
	snd = WhiteNoise.ar();
	snd = HPF.ar(snd, ffreq);
	snd = snd + HPF.ar(snd, ffreq*1.345);
	snd = snd + HPF.ar(snd, ffreq*2.4567);
	snd = snd + HPF.ar(snd, ffreq*4.345);
	snd = LPF.ar(snd, 2000);
	snd = RHPF.ar(snd, ffreq*2, rq) * 0.2;
	snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -10), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Hihat synth                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\hihat, { |out, ffreq=200, rq=0.5, attack=0, release=0.025, amp=0.1, pan|
	var snd;
	snd = WhiteNoise.ar();
	snd = HPF.ar(snd, ffreq);
	snd = RHPF.ar(snd, ffreq*2, rq);
	snd = snd * EnvGen.ar(Env.perc(attack, release, 1, -10), doneAction:2);
	snd = Pan2.ar(snd, pan);
	OffsetOut.ar(out, snd * amp * 2);
	OffsetOut.ar(0, snd * amp);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Reverb unit                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\reverbz, { |in=20, out=100, amp=0.1, mix=0.5, rmix=1, room=0.8, damp=0.8|
	var snd;
	snd = In.ar(in, 2);
	snd = FreeVerb2.ar(snd[0], snd[1], rmix, room, damp);
	XOut.ar(out, mix, snd);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Comb A unit                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\combzA, { |in=22, out=100, amp=0.1, mix=0.5, maxdelay=5, delay=0.05, decay=0.6|
	var snd;
	snd = In.ar(in, 2);
	snd = CombN.ar(snd, maxdelay, delay, decay);
	XOut.ar(out, mix, snd);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Comb B unit                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\combzB, { |in=24, out=100, amp=0.1, mix=0.5, maxdelay=5, delay=0.1, decay=1|
	var snd;
	snd = In.ar(in, 2);
	snd = CombN.ar(snd, maxdelay, delay, decay);
	XOut.ar(out, mix, snd);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Comb C unit                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\combzC, { |in=26, out=100, amp=0.1, mix=0.5, maxdelay=5, delay=0.018, decay=0.35|
	var snd;
	snd = In.ar(in, 2);
	snd = CombN.ar(snd, maxdelay, delay, decay);
	XOut.ar(out, mix, snd);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Mixer unit                                                                      */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\mixer, { |in=100, out, amp=0.1, mix=0.5, maxdelay=5, delay=0.111, decay=2|
	var snd;
	snd = In.ar(in, 2) * 2;
	XOut.ar(out, mix, snd);
  }).store;

  /* -------------------------------------------------------------------------------------- */
  /* Define Compressor unit                                                                 */
  /* ---------------------------------------------------------------------------------------*/
  SynthDef(\compressor, { |in=0, out, amp=0.1, thresh=0.8, slopeB=1, slopeA=0.1, clampT=0.01, relaxT=0.5|
	var snd;
	snd = In.ar(in, 2);
	snd = Compander.ar(snd, snd, thresh, slopeB, slopeA, clampT, relaxT);
	ReplaceOut.ar(out, snd);
  }).store;

/*  q.fx.reverb = Synth.tail(s, \reverbz);
  q.fx.combA = Synth.tail(s, \combzA);
  q.fx.combB = Synth.tail(s, \combzB);
  q.fx.combC = Synth.tail(s, \combzC);
  q.mixer = Synth.tail(s, \mixer);
  q.compressor = Synth.tail(s, \compressor);
  q.pdef = [ Pdef(\chord), Pdef(\ping), Pdef(\peng) ];
  q.scale = [ 0,2,4,5,7,9,11 ]-2;*/

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define ping melody patterns                                                  */
  /* ---------------------------------------------------------------------------------------*/
  q.ping.melodyA = [3,5,7,8, 3,5,7,8, 2,4,6,10, 3,4,6,10];
  q.ping.melodyB = [5,4,3,1, 0,1,0,1,0, -2,-3]+7;
  q.ping.melodyC = [-3,-1,3,1]+7;
  q.ping.melodyD = [0,-2]+7;

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define ping rhythm patterns                                                  */
  /* ---------------------------------------------------------------------------------------*/
  q.ping.rhythmA = 2!16;
  q.ping.rhythmB = [2,2,2,10, 1,1,1,1,2, 1,9];
  q.ping.rhythmC = [2,2,2,10];
  q.ping.rhythmD = [7, 9];

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define first part harmony patterns                                           */
  /* ---------------------------------------------------------------------------------------*/
  q.chords[0] = [1,8];
  q.chords[1] = [5,3];
  q.chords[2] = [1,6,4];
  q.chords[3] = [4,8];
  q.chords[4] = [5,7];
  q.chords[5] = [6,10];

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define second part harmony patterns                                          */
  /* ---------------------------------------------------------------------------------------*/
  q.chords[6] = [1,3,5];
  q.chords[7] = [-3,1];
  q.chords[8] = [-2,1,3];
  q.chords[9] = [-3,-1];
  q.chords[10] = [-3,-1,2];
  q.chords[11] = [-2,1];
  q.chords[12] = [-3,1];
  q.chords[13] = [-5,-2];

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define third part harmony patterns                                           */
  /* ---------------------------------------------------------------------------------------*/
  q.chords[14] = [6];
  q.chords[15] = [5];
  q.chords[16] = [8];
  q.chords[17] = [3];
  q.chords[18] = [6];
  q.chords[19] = [5];
  q.chords[20] = [8];
  q.chords[21] = [10];

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define chord rhythm patterns                                                 */
  /* ---------------------------------------------------------------------------------------*/
  q.chord.rhythmA = [2,2,3.5, 2.5,2,4];
  q.chord.rhythmB = [3.5,4.5,4.5,3.5, 3,5,3,5];
  q.chord.rhythmC = [3.5,4,4,8.5];

  /* -------------------------------------------------------------------------------------- */
  /* [PATTERN] Define pong melody patterns                                                  */
  /* ---------------------------------------------------------------------------------------*/
  q.pong.melodyA = [-1,3,5, 3,5,3, 1,7];
  q.pong.melodyB = [8,6,4,3, 3,4, 3,4,2];
  q.pong.melodyC = [8,9,10, 6,5,2];

  q.pong.rhythmA = [1,2,2,  1,1,1, 1,8];
  q.pong.rhythmB = [2,2,2,2, 2,2, 1,1,9];
  q.pong.rhythmC = [2,2,4, 2,2,3];

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define ping Pdef                                                                */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\ping,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose ping melody patterns                                           */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\scale, q.scale,
		\instrument, \ping,
		\degree, Pseq(
			q.ping.melodyA ++ q.ping.melodyA ++
			q.ping.melodyB ++ q.ping.melodyC ++ q.ping.melodyD ++
			q.ping.melodyB ++ q.ping.melodyC ++ q.ping.melodyD			-1, inf),
		\octave, 6,
		\out, 20,
		\amp, 0.5,
		\dur, Pseq(
			q.ping.rhythmA ++ q.ping.rhythmA ++
			q.ping.rhythmB ++ q.ping.rhythmC ++ q.ping.rhythmD ++
			q.ping.rhythmB ++ q.ping.rhythmC ++ q.ping.rhythmD
			/ 4, inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define chord Pdef                                                               */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\chord,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose chord patterns                                                 */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\scale, q.scale,
		\instrument, \chord,
		\degree, Pseq([
			q.chords[0], q.chords[1], q.chords[2], q.chords[3], q.chords[4], q.chords[5],
			q.chords[0], q.chords[1], q.chords[2], q.chords[3], q.chords[4], q.chords[5],
			q.chords[6], q.chords[7], q.chords[8], q.chords[9],
			q.chords[10], q.chords[11], q.chords[12], q.chords[13],
			q.chords[6], q.chords[7], q.chords[8], q.chords[9],
			q.chords[10], q.chords[11], q.chords[12], q.chords[13]			] -1 + 7,inf),
		\legato, 1,
		\octave, 4,
		\out, 20,
		\amp, 0.25,
		\dur, Pseq( q.chord.rhythmA ++ q.chord.rhythmA ++ q.chord.rhythmB ++ q.chord.rhythmB / 2, inf )
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define chordB Pdef                                                              */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\chordB,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose chord patterns                                                 */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\scale, q.scale,
		\instrument, \chord,
		\degree, Pseq([
			q.chords[14], q.chords[15], q.chords[16], q.chords[17],
			q.chords[18], q.chords[19], q.chords[20], q.chords[21]
			] -1 + 7,inf),
		\legato, 1,
		\octave, 4,
		\out, 20,
		\amp, 0.25,
		\dur, Pseq( q.chord.rhythmC / 2, inf )
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define pong Pdef                                                                */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\pong,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose pong patterns                                                  */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\scale, q.scale,
		\instrument, \pong,
		\degree, Pseq(
			q.pong.melodyA ++
			q.pong.melodyB ++
			q.pong.melodyA ++
			q.pong.melodyC
			- 1, inf),
		\octave, 4,
		\out, 20,
		\amp, 0.5,
		\legato, 2,
		\dur, Pseq( q.pong.rhythmA ++ q.pong.rhythmB ++ q.pong.rhythmA ++ q.pong.rhythmC / 4, inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define kick Pdef                                                                */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\kick,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose kick patterns                                                  */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\instrument, \kick,
		\freq, 80,
		\sustain, 0.1,
		\out, Prand([0,0,0,0,0,0,0,0,0,0, 22, 24, 26], inf),
		\amp, 0.1,
		\dur, Prand([
			Pseq([3,3,1,1]/4),
			Pseq([3,5]/4),
			Pseq([1,2,1,4]/4),
			Pseq([1,2,2,1,1,1]/4),
			Pseq([8]/4),
		],inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define snare Pdef                                                               */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\snare,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose snare patterns                                                 */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\instrument, \snare,
		\sustain, 0.1,
		\out, Prand([0,0,0,0,0,0,0,0,0,0, 22, 24, 26], inf),
		\amp, Prand([
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,0]/2),
			Pseq([0,0,1,1]/2),
			Pseq([1,0,0,0]/2),
			Pseq([1,1,0,1]/2),
			Pseq([1,0,1,0]/2),
			Pseq([1,1,1,1]/2),
		], inf),
		\dur, Pseq([1,1,1,1]/4,inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define hihat Pdef                                                               */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\hihat,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose hihat patterns                                                 */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\instrument, \hihat,
		\sustain, 0.1,
		\out, Prand([0,0,0,0, 22, 24, 26], inf),
		\amp, Pseq([1,1,1,1]/10,inf),
		\dur, Pseq([1,1,1,1]/4,inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Define bass Pdef                                                                */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\bass,
	/* -------------------------------------------------------------------------------------- */
    /* [PBIND] Combine/compose bass patterns                                                  */
    /* ---------------------------------------------------------------------------------------*/
	Pbind(
		\instrument, \bass,
		\freq, Prand([80, 120],inf),
		\sustain, 0.1,
		\out, Prand([0,0,0,0,0,0,0,0,0,0,20], inf),
		\amp, 0.075,
		\dur, Prand([
			Pseq([16]/4),
			Pseq([16]/4),
			Pseq([16]/4),
			Pseq([16]/4),
			Pseq([8]/4),
			Pseq([8]/4),
			Pseq([3,5]/4),
			Pseq([7,1]/4),
		],inf)
	)
  );

  /* -------------------------------------------------------------------------------------- */
  /* [INSTANTIATION] Instantiate synths previously defined with SynthDef                    */
  /* ---------------------------------------------------------------------------------------*/
  q.fx.reverb = Synth.tail(s, \reverbz);
  q.fx.combA = Synth.tail(s, \combzA);
  q.fx.combB = Synth.tail(s, \combzB);
  q.fx.combC = Synth.tail(s, \combzC);
  q.mixer = Synth.tail(s, \mixer);
  q.compressor = Synth.tail(s, \compressor);
  q.pdef = [ Pdef(\chord), Pdef(\ping), Pdef(\peng) ];
  q.scale = [ 0,2,4,5,7,9,11 ]-2;

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Set Pdefs to default to the stopped state                                       */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\ping).stop;
  Pdef(\pong).stop;
  Pdef(\chord).stop;
  Pdef(\kick).stop;
  Pdef(\bass).stop;
  Pdef(\hihat).stop;
  Pdef(\snare).stop;


  /* -------------------------------------------------------------------------------------- */
  /* [TEMPOCLOCK] Set up tempo relative scheduling for project                              */
  /* ---------------------------------------------------------------------------------------*/
  TempoClock.default.tempo = 1.25;

) // Here is the closing parenthesis for this execution block

/* -------------------------------------------------------------------------------------- */
/* [TROUBLESHOOTING] Troubleshooting common problems                                      */
/* ---------------------------------------------------------------------------------------*/

/*
  General Troubleshooting
  -----------------------------------------------------------------------------------------
  With relatively complex projects, glitches may occur in the system. A common source of
  issues is zombie processes. If you attempt to reboot the scsynth server and the server
  exits with an error code it is possible that there is a zombie scsynth instance. You may
  not be able to end this process by running the 'Kill All Servers' functions in the scide
  Server menu. In that case, close scide and check your OS task manager to see if any
  Supercollider processes are still running. In principle, they should not if you have
  closed the IDE. But it can happen for a variety of reasons. If there are, kill the
  processes and restart the IDE. If that fails, an OS reboot may be necessary, but this
  usually works.

  Project Specific Troubleshooting
  -----------------------------------------------------------------------------------------
  While refactoring this project, I noticed certain recurring issues. The principle issues
  revolve around the scsynth server and are probably largely the result of the way that I
  have been setting the server options after startup. I will now experiment with setting
  server options during startup instead and I will make changes to the code accordingly if
  necessary. It is probably

*/