/**
  Project: Bophex-Flim
  File: percussion/percussion-synths.scd
  Author: Leonard M Reidy
  Source:
  Docs: [ http://supercollider.sourceforge.net/wiki/index.php/User_FAQ ]
  Description: This file contains a first run at isolating synth/SynthDef elements of the bophex-flim project for further analysis, specifically:

    - SynthDefs for all percussion elements
    - a subset of the SynthDefs for FX (reverb and combs)
    - tempo control

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
			Pseq([3,5]/2),
			Pseq([1,2,1,4]/4),
			Pseq([1,2,2,1,1,1]/4),
			Pseq([8]/4),
		],inf)
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
  /* [INSTANTIATION] Instantiate synths previously defined with SynthDef                    */
  /* ---------------------------------------------------------------------------------------*/
  q.fx.reverb = Synth.tail(s, \reverbz);
  q.fx.combA = Synth.tail(s, \combzA);
  q.fx.combB = Synth.tail(s, \combzB);
  q.fx.combC = Synth.tail(s, \combzC);
  q.mixer = Synth.tail(s, \mixer);

  /* -------------------------------------------------------------------------------------- */
  /* [PDEF] Set Pdefs to default to the stopped state                                       */
  /* ---------------------------------------------------------------------------------------*/
  Pdef(\kick).stop;
  Pdef(\hihat).stop;
  Pdef(\snare).stop;

  /* -------------------------------------------------------------------------------------- */
  /* [TEMPOCLOCK] Set up tempo relative scheduling for project                              */
  /* ---------------------------------------------------------------------------------------*/
  TempoClock.default.tempo = 1.25;

) // Here is the closing parenthesis for this execution block