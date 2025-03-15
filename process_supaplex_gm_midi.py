from mido import *

mid = MidiFile('supaplex_001.mid')

mid2 = MidiFile(type=0)
track = MidiTrack()
mid2.tracks.append(track)

msg = Message('control_change', channel=1, control=7, value=127, time=0)
track.append(msg)
print(msg)

msg = Message('control_change', channel=2, control=7, value=127, time=0)
track.append(msg)
print(msg)

msg = Message('control_change', channel=3, control=7, value=127, time=0)
track.append(msg)
print(msg)

msg = Message('control_change', channel=9, control=7, value=127, time=0)
track.append(msg)
print(msg)

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

	if idx < 310:
		try:
			if not msg.is_meta:
				if msg.type=='program_change':
					if msg.program==30 or msg.program==32: msg.program=81
					if msg.program==89: msg.program=57 # ?
					if msg.program==37: msg.program=6 # ?
					if msg.program==107: msg.program=90

				if msg.type!='control_change' and (msg.channel==1 or msg.channel==2 or msg.channel==3 or msg.channel==9):
					track.append(msg)
					print(msg)
				else:
					if msg.time!=0:
						track.append(msg)
						print(msg)
		except:
			True

mid2.save('gm.mid')

fin = open('gm.mid', 'rb')
data = bytearray(fin.read())
fin.close()

data[13] = 0xf4

fin = open('gm.mid', 'wb')
fin.write(data)
fin.close()
