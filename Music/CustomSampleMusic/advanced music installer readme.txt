Advanced music installer readme


	CONTENTS

1. Introduction & new features
1a. About the suite
2. Inserting songs
3. Setting up voice tables
4. Using custom samples
4a. GS synth samples
4b. Creating a soundfont from a voice table
5. Notes on file formats
6. Useful programs
7. Special thanks


	1. INTRODUCTION & NEW FEATURES

So, what makes this installer "advanced" and why do we need it? In addition to letting us install custom songs with Event Assembler,
the installer lets us install custom voice tables (using the native instrument map as a base) as well as custom instrument samples:
want the orchestra hit from FE6? How about a trumpet from FE12? Synth instruments from Golden Sun? Samples that you recorded
or synthesised yourself? The world is your oyster.

	- I don't care about using custom instruments in my game. Should I still use this?

Absolutely! Even if you only ever intended on using the native instrument map (NIMAP) and songs using those instruments in the game,
the advanced music installer is still an improvement over the old one. The principal reason is that it, unlike the native instrument map,
supports key splits. A key split is basically a pointer to a mini-instrument map and a chart telling the game which sample to use for
which notes. For example, instrument 48 (string ensemble 1) is set up for a key split that only uses samples meant for low notes if
the notes are actually low. The reason why the trumpet (instrument 56) sounded so weak before is that the native instrument map
uses a sample meant for high notes but not the one meant for mid-range notes; the advanced music installer gives it a key split
so it can use both suitably and bam, now you've got a proper trumpet to play around with! Additionally, even if you don't intend on
inserting any new samples, you can customise the voice table to your liking: for example, if you want instrument 29 to actually sound
like a guitar instead of being an electric piano meant for low notes (one of several weird instrument assignments that were preserved for
legacy/compatibility purposes), you can easily swap it out with a synth lead like instrument 103 or 104. If you just want to make an
alternate version of the instrument that has, say, a slower onset or a staccato sound, you can do that too.


	1a. ABOUT THE SUITE

The advanced music installer suite, as I've come to call it, is basically a pre-prepared music folder for your project. It contains several
useful things to get started, including the music installer itself, note charts to set up the multi-sample instruments, SoX to convert .wav
files into insertable raws, s2EA for conversion of the .s format to .event, and sound_font_riper so you can create a soundfont from
your edited voice table for your own convenience when making music. There's also a test song that the installer will install by default
over the FE8 intro movie song (The Valiant) so you can confirm it's working.

Note that the base music installer was made with FE8 in mind; it will work with FE6/7 (and presumably any other GBA game that uses
the M4A engine), but you will have to change the offsets yourself if you wish to use instruments already in the game. Different games
have the instruments located in different places and trying to just plug the installer into another game with no changes will crash the game.


	2. INSERTING SONGS

The method for inserting songs hasn't changed at all, but I'll go through it here for completion's sake.
Take your .mid file and drag it onto mid2agb.

	- mid2agb is just showing me some error message in Japanese instead of converting my song!

This probably means there is a problematic event somewhere in your midi file. View your midi's event list in whatever app you're using
to edit it and delete any system-exclusive events you find. Additionally, the "repair song" function of Anvil Studio is very useful for
cleaning things up (it will delete your [ ] cues used to make the song loop, though, so take extra care to add them back).

Now that you have your .s file, open it in Notepad as if it were a regular text file. The main points of interest here are [songname]_grp
and [songname]_mvl. "grp" refers to the voice table (or "group") that will be used for the song's instruments. The default given to you
by mid2agb is voicegroup000, but you'll want to change this to whatever you defined your chosen voice table as in your music installer.
In the default installer, that would be MusicVoices, but if you were to add another voice table for use by a specific song, you would
put the name of that one here instead. "mvl" refers to the master volume level of the song. It will take some listening and fine-tuning
to find the perfect volume, but a good place to start is 64, assuming the max volume of your instruments in the midi is 127.

	- What do you mean, 127? The volumes in my midi won't go above 100.

This is probably because of an annoying default option in Anvil Studio where volumes are displayed on a range of 0% to 100% instead
of 0 to 127. Go to View ->Options and check the box for all volumes to be referred to as 0-127 to fix this.
You'll notice that if you export a midi from a GBA game, the volumes of everything will usually be pretty low, using 64 as the max. These
volumes assume that the master volume of the song in-game is 127.

Balancing the volumes of your songs can be tedious, but it's very important: if your music is too loud, it will make ugly popping/crackling
noises. If it's too quiet... well, it'll be too quiet, and it would be a real shame if the player couldn't very well hear the cool music you
worked so hard on!

There's another interesting parameter in song files, "rev" that refers to reverb (basically, makes notes echo a bit). I would recommend
just leaving this at 0 unless you know what you're doing with it/are willing to test a bunch of different things working together, but it
does work. 0 is off; 0x80-0xff is the minimum to maximum reverb. The main reason why I advise against using this is that reverb is
more intensive on the GBA's memory and I'm unsure if the current music hacks we use account for this (the "16 tracks, 12 sounds"
patch comes to mind: you may need to dial it back to a lower number of tracks/polyphony to have reverb and that's not worth it).
However, there's also the fact that reverb applies to all streamed audio, not just the music. This means that many sound effects will
also reverberate and will make it sound like your game is taking place inside a cave. GBA Fire Emblem songs actually have a technique
that sounds like reverb, but isn't really reverb, by placing a second note at half volume or less after each note in a sequence.
It's how a lot of FE8's music gets that nice echoey sound to it; if you're curious, I would recommend dumping some songs from the
game yourself to see how they do it.

Anyway, now that we've got ourselves a nice .s file, drag it onto s2EA to turn it into an .event file and we're finally ready to include it
in the installer.

Songs should go at the beginning of your music installer. In the example installer, you'll find a section labeled "macro definitions for
setting the song table". Of immediate interest is the SongTable macro, which you will use to insert songs. The "index" parameter
refers to where in the song table you're inserting it; for example, if you insert it at 0x9, the song will play when you use the event
MUSC 0x9, have the player/enemy/ally phase music set to 0x9 in the chapter data editor, etc. The SongPointer parameter should
just be your song's filename but without the extension. When you assemble your build file, the assembler will insert the song
at whatever point it currently is and then automatically assign a pointer to the song table that tells it the song is located at this location.
The "Group" parameter refers to which priority group the song is in; basically, which slot it will occupy in the GBA's memory.
Battle music is group 0, map music is group 1, and sound effects are group 6. Ever had a situation where you changed some vanilla
battle music to be map music, but then it wouldn't properly resume playing after a battle? That was because it still had the wrong
priority group assigned to it. As far as I know, you can put cutscene music in any slot you want and be fine, but I would
recommend using 2. Why, you ask? This is because if you have a scripted battle in your cutscene, you'll want the battle music and the
cutscene music to occupy different spaces in memory so the cutscene music can properly resume playing after the battle is over.
Additionally, if you had a brief event taking place during a chapter in which cutscene music plays (recruitment is the big one, but there
are other possibilities, like bad guy music playing when enemy reinforcements come in and their commander tells them to charge or
whatever), the player/enemy/ally phase music would be able to pick up playing again right where it left off after the event with no problems.

Going back to song insertion, here is an example SongTable macro:

{
SongTable(0x1,mysong,0)
#include "songs/mysong.event"
}

This inserts a song that would replace "The Valiant", the opening movie theme. Since I use the hack that removes the opening movie,
I like to use entry 0x1 for quick testing purposes because, without the opening movie, it's effectively unused by the game. It's also
the first song in the Sound Room, so it's easy to quickly navigate there through the main menu to hear how the song sounds in-game.

	- My music isn't playing in-game! It's either vanilla Fire Emblem music or silence.

The "music array editor" Nightmare module can interfere with this installer; it will see the changed pointers in the song table and
"helpfully" change them back to the vanilla ones for you. Go into your Nightmare modules and cut/paste the spreadsheet for it
somewhere else where c2EA won't process it. Make sure to run c2EA again afterward so it updates your Nightmare table installer.

	- EA is giving me an error that it can't find "voicegroup000".

voicegroup000 is the default voice table name given to a song that is processed by mid2agb. After you use mid2agb to convert your
.mid song to an .s file, open the .s file in Notepad and change the voicegroup000 at the beginning to the name of whatever voice table
the song should be using (in the example installer, that would be MusicVoices).


	3. SETTING UP VOICE TABLES

Included in the suite is a "basic" music installer that will install a voice table equivalent to using the native instrument map and the
FE8 drum fix, with lots of comments to explain what's going on.
A voice table, like the song table, is comprised of entries. I've put lots of comments right below the definitions for the voice table macros
to illustrate what's going on with each one of them; I'll go over them in example format here.

VoiceDirect(MusicVoices,0x6,0x3c,0x028F524,0x0,0x0,0x0,0xff,0xf9,0x0,0xb0)

Here's the macro for instrument 0x6, the harpsichord. It's part of the voice table called MusicVoices, so we have the name of the
table first to tell EA it should be writing this entry, made up of 0xc bytes, to wherever is the location of MusicVoices + 0xc * 0x6.
0x6 is the index, or instrument slot. It means this entry will be used when the song is playing instrument 0x6.
0x3c is the base note, C3 (the middle of the piano). Other base notes only work with drums (that is, voices that are part of a VoiceDrum
table), so if you have a single tom sample, you can turn it into a low tom, mid tom, high tom, etc, by having different voice slots with
different base notes. If you want to give your drums some interesting flair without inserting any new samples, this is the way to do it.
Try giving a crash cymbal a lower base note for a dramatic "gong" sound! GBA FE doesn't support variable base notes with actual
instruments, so 0x3c will be the base note for all of your other voice table entries. Note that you should have fixed frequency turned
off if you want to give a sample a different base note than 0x3c.
0x028F524 is the location of the sample. There's just an address here because it's a sample already in the rom (this is why we
call them "native instruments", because they're already in the rom), but if we were to use a custom harpsichord sample, it would
be a label instead. For example if we had:

VoiceDirect(MusicVoices,0x6,0x3c,HarpsichordSample,0x0,0x0,0x0,0xff,0xf9,0x0,0xb0)

After the voice table in our installer, when we're including sample data, we would have something like:

HarpsichordSample:
SampleHeader(0x1,0x00A44000,0x00002332,0x00003f33)
#incbin "samples/harpsichord.sb"
ALIGN 4

This means EA would see HarpsichordSample and plug in wherever it assembled the sample as the location for the pointer in
our instrument table. Don't worry about that spooky SampleHeader macro for now; it's covered in the next section.

	- What does ALIGN 4 do? Why are there so many of them?

ALIGN 4 just adds padding until the next offset that's divisible by 4. I typically use this after every single sample I #incbin because
samples can potentially have weird lengths, and using offsets that are not multiples of 4 (e.g. 0x01002fb instead of 0x01002fc)
will result in EA refusing to assemble your build file, or if it does it will result in things breaking in-game.

Anyway, back to the VoiceDirect macro: the 0x0 after the pointer is whether or not the instrument has fixed frequency: this is usually
only used for drums. It means the sound engine will lock the frequency of the sample at 13379Hz (or, if you've changed the engine's
playback frequency, whatever you've set that to) so it will always sound the same regardless of where it is on the scale.

The next 0x0 in our harpsichord macro refers to whether or not there is forced panning. This is also usually only used in drums. 

The next 0x0 is, if forced panning was turned on, how much the sample should be panned. 0x0 is off; 0x80 is all the way to the left;
0xff is all the way to the right. Values below 0x80 but above 0x0 aren't used.

The last four bytes, starting with the 0xff, are our sample's envelope, or how the game alters its volume. This sample in particular
has an attack of 0xff (meaning it will instantly start playing at 100% volume rather than fading in), a decay of 0xf9 (meaning it will
fade out in volume very slowly), a sustain of 0x0 (meaning it will not stop fading out until the volume hits 0), and a release of 0xb0
(meaning it will take a medium amount of time for the note to fade out after the key is released). If you play around with these
values a bit, you can get a feel for how they work and how you can use them to make instruments have different envelopes for
different musical situations.

That covers the VoiceDirect macro. Next, I will go over an example of the VoiceMulti macro, used for key splits:

VoiceMulti(MusicVoices,0x31,Strings2Table,C3toC5Chart)

Here's the macro used for one of the string ensembles in our installer.
The first two parameters are identical to those in VoiceDirect: we're telling EA this is entry 0x31 of MusicVoices.

Strings2Table is a label referring to a pointer to another voice table, used for the samples in our multi instrument.
Here's what Strings2Table looks like:

Strings2Table:
VoiceDirect(Strings2Table,0x0,0x3c,0x022B4DC,0x0,0x0,0x0,0x80,0x0,0xff,0xa0)
VoiceDirect(Strings2Table,0x1,0x3c,0x0233650,0x0,0x0,0x0,0x80,0x0,0xff,0xb0)
VoiceDirect(Strings2Table,0x2,0x3c,0x02A0690,0x0,0x0,0x0,0xff,0x0,0xff,0xd0)
ORG Strings2Table+0x0c*3

As you can see, it's literally just another voice table, although it's a miniature one since it only has three entries. Since our
key split only uses these three samples, there's no reason to have any more. The ORG at the end tells EA that it should resume
writing data at the location of the beginning of the table plus however many entries there are. This is a safeguard against voice tables
overwriting one another. The number at the end should match how many entries there are in the tables; for example, if our table had
four entries instead of three, it would be ORG Strings2Table+0x0c*4. Remember, we count up from 0, not 1!

C3toC5Chart refers to a note chart; in this case, one that tells EA to use sample 0x0 for the C3 octave, 0x1 for the C4 octave, and
0x2 for the C5 octave. Here's what the included .dmp file looks like:

00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 01 01 01 01 01 01 01 01 01 01 01
01 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02

As you can see, it's literally a series of 00, 01, and 02 telling us which notes on the keyboard use which sample. It will almost always
be 0x80 in length. When creating a note chart in your hex editor, it can be easy to lose track of which byte is which note, but fortunately
we have a handy mnemonic: 0x3C is C3. Twelve notes is an octave.

Finally, we have the VoiceDrum macro:

VoiceDrum(MusicVoices,0x7c,0x02228F0)

This is the macro for instrument 124, the rock drum kit. We first have MusicVoices and 0x7c to tell the assembler that it's instrument
0x7c of the MusicVoices table, then an offset pointing to a voice table. In this case, we're just using the offset of a table that already
exists in the game, but we could change this to, say, RockDrumTable and then makes a voice table out of VoiceDirect entries there,
the same way we did with the key split earlier. The main difference with drum voices is that they will almost always have the "fixed
frequency" and "forced pan" values enabled. The fixed frequency makes sure the drums never sound out of tune because of their
position in the table, and the forced pan makes them sound more dynamic and lets you play more drums at once without their sounds
all blending together. For example, if a highhat were on the same pan as a bass drum, the former would easily overpower the latter.


	4. USING CUSTOM SAMPLES

Although an instrument sample starts its life as a .wav file, the file you're going to be assembling to the rom will be a .dmp, .sb, or .s,
depending on which method you use to get the raw data. A .dmp or .s already has the header (data at the beginning telling the game
what frequency to use, whether or not the sample loops, how long is the sample, and when is the loop point) built in. An .sb is just
the audio data and it's up to the installer to include a header.

To make a .dmp file, make a copy of a vanilla rom to use as a "dummy" rom. Open it in your hex editor and take note of the offset
of the end of the rom (it's easiest to insert samples here). Now open the rom in Sappy (or something else that can import/export
samples) and use "Import sample" to import your .wav file (make sure to check the box saying it's looped and specify the loop point).
Close Sappy and open the rom in your hex editor again, copy all the data from where you imported the sample to the end of the rom,
and paste it into a new file. Save this file as a .dmp and it's all ready for you to #incbin in your music installer.

An .sb file is a little more involved in assembling to the rom, but it's recommended over a .dmp because you don't have to do a
weird dance of using Sappy to insert something into a dummy rom and copying the resulting data out. Additionally, it's a lot less
prone to slip-ups than manually copying oodles of data out of a rom: if you have to do that for more than just a few samples, your
eyes *will* glaze over. We'll be using a little app called SoX for this.

(Note: the version of SoX included with the installer suite is the Windows version, but there are also versions available for Mac and Linux
at http://sox.sourceforge.net.)

To use SoX to convert a .wav sample to .sb, open cmd.exe (the Windows terminal) and navigate to the folder where sox.exe and your
audio file are stored. A useful tip to quickly open cmd.exe is to click on the Windows Explorer location bar (the one showing the location
of your folder, analogous to the bar in a web browser that shows you the URL) and type "cmd" into it to open a command prompt window
right inside the folder instead of starting in C:\ and having to navigate your way to SoX manually every time.

Run sox.exe using this command:

sox NAME.wav -r FREQ -c 1 NAME.sb

NAME should be replaced with the sample's filename
FREQ should be replaced with the frequency (Hz) of the sample

If successful, sox.exe will output your audio sample as an .sb file. If you haven't done so yourself, this will also conveniently convert
the sample's bit rate to 8-bit for you (I accidentally forget to do this all the time when editing audio). You can install this file by using
an #incbin preceded by a SampleHeader macro.

The SampleHeader macro requires four parameters: IsSampleLooped, SamplePitchAdjustment, SampleLoopPoint, and SampleLength.
Following is an explanation of each.

IsSampleLooped: 0x0 for no loop. 0x1 if there is a loop. Most instruments that aren't drums will have looped samples; looping enables
us to have a file that's, say, only one second long repeat the last half-second over and over again if you have a note that holds longer
than one second.

SamplePitchAdjustment: the frequency of your sample converted into a special value interpreted by the sound engine.
For quick reference, here's a list of common values from bregalad's GBA sound engine documentation:
0x00599800  (5734 Hz)
0x00688800  (6690 Hz)
0x007b3000  (7884 Hz)
0x00a44000  (10512 Hz)
0x00d10c00  (13379 Hz)
0x00f66000  (15768 Hz)
0x011bb400 (18157 Hz)
0x01488000 (21024 Hz)
0x01a21800 (26758 Hz)
0x01ecc000 (31536 Hz)
0x02376800 (36314 Hz)
0x02732400 (40137 Hz)
0x02910000 (42048 Hz)

To manually calculate the pitch adjustment, take your frequency, multiply it by 1024, and convert it into an eight-digit hexidecimal value.
(The "Programmer" view in the Windows calculator is useful for quickly converting from decimal to hexidecimal)
For example, 22050Hz becomes 0x01588800.

SampleLoopPoint: the loop point of your sample, converted to an eight-digit hexidecimal value. For example, 4000 becomes 0x00000fa0.

SampleLength: the length of your sample in samples (in this case, the more technical definition of "sample" where it refers to the
points on a graph that tell your sound hardware how to play the audio), converted to an eight-digit hexidecimal value. For example,
12000 becomes 0x00002ee0 (yes, I do recommend preserving those leading zeroes). To quickly find the length of your sample, just
open up the .sb file in your hex editor, use "select all" to select the entire thing, and take note of the selection's length, which is the same
as the length of your sample. This is identical to the number you would get if you were to look at the sample's length in OpenMPT or
another app and convert that number to hexadecimal.
With this, you've converted your sample and set up a proper header for it so now it's all ready to #incbin.

Before moving on, I would like to briefly talk about the .s format as it pertains to samples. Using Sappy or m4a2s (an application made
by ipatix for dumping .s files), you can dump samples from a rom in .s format. You can feed these .s files to s2EA in the same way as
you would a song in .s form, but you need to take an extra step to insert them. Open the .event file in Notepad and delete all the
preliminary comments and labels (the first word in the document should be SHORT). Change all instance of .int at the beginning to
WORD and convert the values following them to eight digits (e.g. 18060 becomes 00018060). After this, the sample in .event form
is ready to be #included (just a regular #include, not #incbin). An .s file already contains header information, so there's no need for a
SampleHeader macro. .s is probably your best bet if you want something friendlier than a raw hex file, don't want to mess with the
sample header, and/or just want to insert a sample from another GBA game as-is rather than directly converting from .wav.

	- Why can't I just use wav2gba?

wav2gba requires any audio file it processes to be 22050Hz in frequency. While this is fine for things like FE:Echoes-style voice acting,
it is not ideal for music purposes. If you are inserting an instrument sample, keep in mind that the file's frequency is its frequency at C3
(the middle of the proverbial piano); if you play a higher note, the frequency will be increased so the pitch increases as well. 22050Hz
is fine as a frequency for mid-range notes, but when you start to go too high or too low it can become distorted. Since the default
frequency of a sample in GBA FE is 13379Hz, if you encounter a sample whose frequency is 26758 that means its base note (the note
at which the frequency is 13379) is C2, so it will sound better at lower pitches and worse at higher pitches. Likewise, if the sample's
frequency is 6690, the intended base note is C4. Keeping this logic in mind is important when making key splits; uniformly using
22050Hz for samples based on C1, C2, C3, C4, and C5 would mean a C5 would sound just a shrill as it would being played by the
C3 sample (as a general rule of thumb, you don't want your samples to go above 40000Hz or so in frequency). You could use wav2gba
for drums, which typically have fixed frequencies and do not loop, but again it's not ideal because there's no reason for a drum sample
to be any higher than 13379Hz (even if you change the game's audio playback frequency, 22050 is not one of your options).

	- How should I decide which frequency to make my instrument samples?

As I mentioned before, the frequency of the samples already in the game is 13379Hz and you should avoid going above 40000Hz or so
(note: this is just for a sample meant to play C3 as its base; you can, for example, insert a sample meant to play around the C1 range
with 84096Hz and when it plays the C1 it will be shifted down to 21024).
If you are in doubt about what frequency you should be using, I would recommend just sticking with whatever your sample's frequency
already is, provided you took it from another GBA game (for example, a Golden Sun sample would typically be 15768Hz). If you are
making a multi sample instrument that will be using a key split, a sample based on a note an octave above the previous sample should
have a halved frequency: for example, if C3 is 21024, that means C4 is 10512, C5 is 5256, etc. Remember, the frequency of the sample
should be its frequency at C3. The game will adjust it up or down for you when your music's notes are playing it in-game. If you're really
still in doubt and just want to insert a single sample for use by an instrument, just stick with 13379, since that is the default playback
frequency used by GBA FE. Maybe go with 6690 if you want it to sound best at C4 or 26758 for C2.

	- If I have a note playing for long enough, my sample plays an ugly repeating clicking sound! How do I fix this?

This probably means your sample is badly looped. To fix this yourself, I recommend opening your sample in OpenMPT. Drag your
.wav into the OpenMPT window and click on the "Samples" tab of the little window that pops up if you're not there already. Play back
the sample (the music note button) and listen for the clicking noise, then compare the loop end point with the length ("len") of your
sample. The GBA game will only check for a loop start point and automatically use the end of the sample as the loop end point, so be
sure to delete anything after the loop end point until the sample length and location of the end point are identical (tip: you can highlight
a selection and press the space bar to zoom in on only that selection; this is useful for zooming in to see very small details like a few
rogue samples hanging out at the end of your audio file). Be especially wary if you use Wavosaur to edit your audio file; Wavosaur has
a nasty habit of inserting an empty sample right at the end of the file that will produce that clicking noise if you don't delete it.
If the clicking noise still isn't fixed, you can try cross-fading the sample's loop to make it sound smoother. The button that you want is
the little icon of a green wave on a black graph. OpenMPT will ask you how long you want the fade to last and whether you want to
prioritise volume or power; experiment around with these options and you can get a feel for what they do.

	- My sample is out of tune!

Again, OpenMPT can help a lot with this. Open your .wav in OpenMPT and click the button that looks like a yellow tuning fork. This
will open a dialog asking for your desired note; for us, this will always be C (also referred to as C-), so there's no need to change
anything here. Your sample's frequency will be adjusted up or down to the closest C note. It's totally normal for a sample to be "off"
by a few hundred Hz or so; sometimes, being slightly detuned (but still closer to C than B or C#) is what gives an instrument its flair.
However, if the frequency got adjusted by a substantial amount, the sample probably was out of tune after all. OpenMPT's tone
detection isn't infallible (very rarely, you will find a sample that it insists on tuning to the wrong note because of some background
harmonic noise that it identifies as C), but it is much better than anything a human ear can do (again, unless it's obviously wrong).
If your sample sounds fine when you play it back yourself but out of tune in-game, double-check the values in your SampleHeader
macros (especially make sure the SamplePitchAdjustment value is correctly calculated from your sample's frequency). I myself got
them confused several times when I was creating the installer and believe me, it doesn't sound pretty when that happens!

	- These things take up a huge amount of space! I can't insert the entire Fire Emblem series's music into my game like this!

It's true; audio data is gigantic. It's why our game uses sequenced music (midi) instead of just having all the music be recordings
in the first place. You're going to have to strategically re-use samples here and there: for example, if you insert one string ensemble
from game A and another from game B, and they both only sound slightly different, just keep one and use it for both roles.
This is a place where you're going to want to go for quality over quantity: people will appreciate a good-sounding instrument but they
probably won't even notice three instruments of the same type that all sound similar. This is one of several reasons why I encourage
people to use their own instrumentation for songs imported from other games rather than obsess over making it sound 100% like the
original game. Not only does it let you express yourself and add your own personal touch to the music; it's downright efficient.

	- I loaded an emulator state while testing and the game glitched out with horrible screeching sounds!

Keep in mind that sample data is written to the rom by EA every single time you assemble your build file. This means that if you add
stuff to the buildfile before the music installer, everything the music installer writes will be shifted back a certain amount by whatever
new stuff you've added. This means that when you load an emulator state that was saved on a previous version of your rom, the music
currently playing will be looking for songs/instruments/etc in places that are no longer valid. To avoid this happening, don't put the music
installer on the very end of your buildfile; instead, make sure it goes before everything that gets frequently changed/tested, such as
events, animations, etc. You can also try just resetting the game and resuming the chapter from the save file; as opposed to directly
loading from an emulator state, the game will know to look in the right place when you start it up in the expected manner.


	4a. GS SYNTH SAMPLES

"GS" instruments refer to the synth instruments used by Camelot Software Planning (developers of the Golden Sun games), which can be
used in your game too, given you have ipatix's sound mixer installed (it's included with the suite by default). These samples create a simple
waveform based on a mathematical formula rather than on audio data. They are so small in size that I've elected to include them in the
installer (you will find them on instruments 82/83/87/113/114/115); you can easily remove them yourself if you don't want them.
GS synths are useful for emulating the sound of many GBA games, which use square waves alongside Direct samples to make their
music. Since using square waves in music is off limits in GBA FE because square waves are already used for sound effects, you can
"cheat" by using these GS synths as if they were regular samples. There are three types of GS synth: square, triangle, and saw.
The triangle and saw wave do not have any customizable parameters, but you can use GSSquareMacro to make a square wave with
custom parameters. Here's the macro and explanations of the parameters (taken from appendix D of bregalad's Sappy documentation):

GSSquareMacro(InitialDutyCycle,CycleSpeed,CycleAmplitude,CycleOffset) 

InitialDutyCycle: The proportion of the square wave. For example, 0x80 gives you a regular square wave, 0x40 gives you one with
a 25% ratio, and 0x20 is 12.5%. You can use other values for even more variety of square waves, too!

CycleSpeed: the speed of a single cycle.

CycleAmplitude: maximum amplitude the cycle can reach.

CycleOffset: minimum amplitude the cycle can reach.

For example: the most commonly used synth wave in Golden Sun is produced by GSSquareMacro(0x10,0xf0,0xe0,0x80). I have elected
to call this one GSDance in my notes because it reminds me of some electronic dance synth. Another one occasionally used by the GS
games for bass is GSSquareMacro(0x60,0x20,0x30,0x80), which I call GSDanceBass.
Don't worry if you don't understand these parameters; the only one that's really easy to grasp is InitialDutyCycle. You can make
adjustments to the other parameters yourself and listen for the changes if you're curious exactly how subtle they are. Additionally,
you'll find the basic wave shapes (triangle, saw, square50, square25, square12.5) already set up in the example installer.

Keep in mind that GS samples have no aliasing at all applied to them so they'll sound very "raw", sometimes even causing artifacts/noise
if you use them too heavily, so it's better to use them sparingly rather than generously. My personal favourite uses of them are using the
triangle or saw wave as a bass or using one of the square waves to play arpeggios in the background.


	4b. CREATING A SOUNDFONT FROM A VOICE TABLE

If you've edited the game's instrument repertoire at all, I recommend creating a new soundfont from your main voice table so you can
work with the most accurate reproduction while composing and editing music in whatever app you use on your computer. We can use
sound_font_riper, a component of gba_mus_riper, to do this. I've included it with the suite for convenience.

Open the Windows command prompt (cmd.exe) in the folder containing sound_font_riper.exe and a copy of your rom.
Use this command:

sound_font_riper -sFREQ IN.gba OUT.sf2 ADDRESS

Replace FREQ with whatever is the frequency of your drums (or other fixed frequency samples). Unless you've added new samples
with a different frequency (this means you're replacing all of the drums), this will be 13379. If you use a frequency other than 13379, the
vanilla drum samples won't sound accurate in the soundfont. Note that there is no space between the -s and the frequency amount.
Replace IN with the filename of your rom and OUT with whatever you want to call the newly-created soundfont.
Replace ADDRESS with the address of the voice table you want to convert into a soundfont. To easily find this, you can add
"MESSAGE Main voice table begins at CURRENTOFFSET" to your music installer right before your first voice table entry and EA will tell
you exactly where the table is being written when you assemble the build file.

Make sure to add your soundfont in the VirtualMidiSynth configuration window so you can use it in your music editing app of choice.
Personally, I like to keep all of my soundfonts in one folder, but if you have a lot of songs that get their own voice table (thus needing
their own respective soundfont), you may want to keep all your project's soundfonts in their own folder in the music folder.

	- My soundfont sounds like it has a bunch of echo applied to it when I listen to it in my music editing app!

Go to the "Advanced options" tab in the VirtualMidiSyth configuration and make sure "Disable MIDI effects" is ticked.


	5. NOTES ON FILE FORMATS

.mid: a midi. Basically an event list that gets interpreted into a song by whatever software you use to compose/edit music.
.s: the result of a midi being processed by mid2agb. s2EA will convert this into an EA-friendly .event file, which is what ends up
getting assembled into the rom. Samples can also be in .s form and can also be processed by s2EA.
.wav: the file format used for audio samples. Needs to be converted to raw format before assembling.
.sb: a "raw" file format identical to the data you will see if you open the rom in a hex editor. SoX can convert .wav to .sb.
.dmp: used for many things, but in a music context, it is a sample ripped directly from the rom with the header intact.
A sample in .dmp form should be identical to the .sb except with an extra sixteen bytes at the beginning for the header.



	6. USEFUL PROGRAMS

SoX: used to convert .wav files to .sb files that can be assembled to the rom. The Windows version is included with the suite,
but it's available for Mac and Linux as well.
http://sox.sourceforge.net/

Sappy: the app that this installer was created to replace. It is, however, still useful for browsing around the song/voice tables of
a rom, dumping samples, and exporting midi versions of songs.
Sappy:
https://www.dropbox.com/sh/723s9jdkfkx7pwa/AABrXCMghyx2f74fme6iDoTEa?dl=0
Sappy is notorious for being finicky and arbitrarily not working for many people. If you're having trouble running it, try the method
outlined in this forum thread: https://feuniverse.us/t/sappy-working-version/153
Sappy 2006 mod 15:
https://www.dropbox.com/s/zybsqcwurrn3x01/sappy2006mod15.zip?dl=0

OpenMPT: a very useful app that has a lot of nice features for editing samples, among other things. With OpenMPT, you can easily
do things like changing the frequency of a sample so it is correctly tuned, normalizing it to the proper volume, and cross-fading the
sample's loop so it sounds good and doesn't make clicking noises.
https://openmpt.org/


	7. SPECIAL THANKS

There are honestly tons of people I should be thanking, but a handful of individuals stand out (in no particular order):

- bregalad: for the extremely helpful documentation on the M4A ("Sappy") format.
- ipatix: for making a cool new sound mixer and being the person whose work figuring out sound engines was responsible for a lot
of bregalad's doc in the first place.
- circleseverywhere: for the original music installer I based this off of. I'm infinitely glad I had a template to work from and I only had to
worry about figuring out sample data, not song data too.
- Agro: for writing the original Fire Emblem-centric tutorials that helped me get into music in the first place.
- zahlman: for providing insight in the form of ancient forum posts and working on a lot of the old tools that eventually became the
ones that I get to take for granted today.


	DOCUMENTATION

Documentation of bytes for voice table entries:

directsound bytes
byte 0: voice type (default 0). add 0x8 for fixed frequency (usu used for drums). add 0x10 for reverse playback (not supported by GBA FE).
byte 1: base note (should always be $3c, i.e. middle C, for our purposes)
byte 2: always 00?
byte 3: forced pan (80 =0)
bytes 4 thru 7: sample address pointer (78 56 34 08 is 0x0345678)
byte 8: envelope attack
byte 9: envelope decay
byte a: envelope sustain
byte b: envelope release

square1 bytes
byte 0: voice type (default 1). add 0x8 for auto note off w/ noise
byte 1: base note
byte 2: always 00?
byte 3 front bit: sweep time. 00: disable. 10 thru 70: 7,8ms; 15,6ms; 23,4ms; 31,3ms; 39,1ms; 46,9ms; 54,7ms.
byte 3 back bit: sweep shift. 00 or 08: disable. 01 thru 07: add 2 thru 8 bits. 9 thru f: subtract 2 thru 8 bits.
byte 4: duty cycle: 00 12,5%; 01 25%; 02 50%; 03 75%
byte 5: always 00?
byte 6: always 00?
byte 7: always 00?
byte 8: envelope attack
byte 9: envelope decay
byte a: envelope sustain (max 0f)
byte b: envelope release

square2 bytes
byte 0: voice type (default 2). add 0x8 for auto note off w/ noise
byte 1: base note
byte 2: always 00?
byte 3: always 00? (no sweep options for square 2)
byte 4: duty cycle: 00 12,5%; 01 25%; 02 50%; 03 75%
byte 5: always 00?
byte 6: always 00?
byte 7: always 00?
byte 8: envelope attack
byte 9: envelope decay
byte a: envelope sustain (max 0f)
byte b: envelope release

wave memory bytes
byte 0: voice type (default 3). add 0x8 for auto note off w/ noise
byte 1: base note
byte 2: always 00?
byte 3: always 00?
bytes 4 thru 7: wave data address pointer (0x0345678 is 78 56 34 08)
wave data format: a simple chart 16 bytes in length. 0 thru f determines the amplitude (y co-ordinate) of the wave, with btwn 7-8 being 0 dB.
example: 0011223468abcdeeffeeddcb97543211 makes sort of a sine wave. ffffffffffffffff0000000000000000 is a square wave.
byte 8: envelope attack
byte 9: envelope decay
byte a: envelope sustain (max 0f)
byte b: envelope release

noise bytes
byte 0: voice type (default 4). add 0x8 for auto note off w/ noise
byte 1: base note
byte 2: always 00?
byte 3: always 00?
byte 4: noise pattern. 00: 32768 samples; 01: 256 samples.
byte 5: always 00?
byte 6: always 00?
byte 7: always 00?
byte 8: envelope attack
byte 9: envelope decay
byte a: envelope sustain (max 0f)
byte b: envelope release

multi sample bytes
byte 0: voice type (always 40)
byte 1: base note
byte 2: always 00?
byte 3: always 00?
byte 4 thru 7: pointer to voice table
bytes 8 thru b: pointer to note chart

drum part bytes
byte 0: voice type (always 80)
byte 1: base note (unused?)
byte 2: always 00?
byte 3: always 00?
byte 4 thru 7: pointer to voice table
byte 8: always 00?
byte 9: always 00?
byte a: always 00?
byte b: always 00?
