/**
  Project: Bophex-Flim
  File: percussion/hihat--synths.scd
  Author: Leonard M Reidy
  Source:
  Docs: [ http://supercollider.sourceforge.net/wiki/index.php/User_FAQ ]
  Description: This file contains a first run at isolating the hihat synth.

    - SynthDef for hihat
    - a subset of the SynthDefs for FX (reverb and combs)
    - tempo control

  General Notes

  To Execute: Ctrl + Enter (Cmd + Enter on MacOS)
  To hush: Ctrl + . (Cmd + . on MacOS)

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
  /* Define Hihat synth                                                                     */
  /* ---------------------------------------------------------------------------------------*/

  /*
    A SynthDef is a client-side (sclang) representation of a synth definition. The server,
    scsynth, uses these definitions as templates to create fresh Synth nodes. SynthDefs are
    evaluated only once at the time the def is created. This is why code in SynthDefs tends
    to look like configuration. The assumption must be made at all times that any logic
    that presupposes multiple evaluations will fail since there is never more than one
    evaluation.

    Arguably, it is better to think of a SynthDef as a config interface to a black box and to apply
    what are essentially recipes for configuring it. The key points of interest are from lines
    64 to 74. We start with a signal (WhiteNoise), apply a high pass filter (HPF), followed by a
    resonant high pass filter (RHPF). Then, we wire it up to an envelope(EnvGen/Env), center pan
    it (Pan2), output the signal to a couple of buses (OffsetOut), then store the resulting def
    to the scsynth server.

    Note the use of the store method, rather than the more customary add method; this is favoured
    for use with event streams/patterns. Interestingly, the docs also indicate that the add
    method may be used for event streams/patterns, but without the cost of a permanent file
    on disk:

      "After using this method, the synthdef can be used with event streams as in store(), but
       without the permanent artifact of a file on disk."
  */
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
  /* Define FX units                                                                     */
  /* ---------------------------------------------------------------------------------------*/
  /*
     Note that all FX SynthDefs in this project have the same general form:
      - some set of parameters for controlling the unit with suitable defaults
      - an audio rate input (In) UGen piped to an effect like FreeVerb2 or CombN
      - an audio rate output (XOut) UGen


     Inputs
      An In reads a signal from a bus. Recall that the instrument SynthDefs send signals out
     on a bus or buses (OffsetOut) in this project. Audio rate Ins read signals from audio
     buses, while control rate Ins read signals from control buses.


     Outputs
      An XOut sends a signal to a bus, crossfading with previous content. An OffsetOut writes
      a signal to a bus with sample accurate timing.

   */
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
  Pdef(\hihat).stop;

  /* -------------------------------------------------------------------------------------- */
  /* [TEMPOCLOCK] Set up tempo relative scheduling for project                              */
  /* ---------------------------------------------------------------------------------------*/
  TempoClock.default.tempo = 1.25;

) // Here is the closing parenthesis for this execution block
(
  // Dump all OSC messages sent to server to Post Window
  s.dumpOSC(1);
)
