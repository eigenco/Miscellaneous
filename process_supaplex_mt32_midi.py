# python3 m.py|sort -u

from mido import *

mid = MidiFile('supaplex_001.mid')

mid2 = MidiFile(type=0)
track = MidiTrack()
mid2.tracks.append(track)

idx = 0
for msg in mid:
	# fix dosbox capture timing inaccuracies
	if msg.time==0.001: msg.time=0
	if msg.time==0.019: msg.time=0.02
	if msg.time==0.099: msg.time=0.1
	if msg.time==0.11900000000000001: msg.time=0.12
	if msg.time==0.219: msg.time=0.22
	if msg.time==0.23900000000000002: msg.time=0.24
	if msg.time==0.7000000000000001: msg.time=0.7
	if msg.time==0.719: msg.time=0.72
	if msg.time==0.9400000000000001: msg.time=0.94
	if msg.time==2.2600000000000002: msg.time=2.26

	msg.time = round(msg.time*1000)
	idx = idx + msg.time/1000.0
	print(msg)

	if idx < 310:
		try:
			if not msg.is_meta:
				track.append(msg)
		except:
			True

mid2.save('mt32.mid')

fin = open('mt32.mid', 'rb')
data = bytearray(fin.read())
fin.close()

data[13] = 0xf4

fin = open('mt32.mid', 'wb')
fin.write(data)
fin.close()
