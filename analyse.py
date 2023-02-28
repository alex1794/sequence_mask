import numpy as np
import matplotlib.pyplot as plt

filename = ["time_align",   "time_unroll",   "time_intrin",   "time_align_omp",   "time_unroll_omp",   "time_intrin_omp"]
time_gcc = np.zeros((6,31))
time_clang = np.zeros((6,31))
time_icx = np.zeros((6,31))

bw_gcc = np.zeros((6,31))
bw_clang = np.zeros((6,31))
bw_icx = np.zeros((6,31))

i = 0
for name in filename:
	data = []
	with open(name+"_gcc.txt", "r") as file:
		rows = file.readlines()
		for row in rows:
			data.append(row.strip().split(" "))
	data = np.array(data, dtype=float)
	elapsed = data[:,0]
	bw = data[:,1]
	time_gcc[i] = elapsed
	bw_gcc[i] = bw
	i+=1

i = 0
for name in filename:
	data = []
	with open(name+"_clang.txt", "r") as file:
		rows = file.readlines()
		for row in rows:
			data.append(row.strip().split(" "))
	data = np.array(data, dtype=float)
	elapsed = data[:,0]
	bw = data[:,1]
	time_clang[i] = elapsed
	bw_clang[i] = bw
	i+=1

i = 0
for name in filename:
	data = []
	with open(name+"_icx.txt", "r") as file:
		rows = file.readlines()
		for row in rows:
			data.append(row.strip().split(" "))
	data = np.array(data, dtype=float)
	elapsed = data[:,0]
	bw = data[:,1]
	time_icx[i] = elapsed
	bw_icx[i] = bw
	i+=1

a = np.mean(time_gcc, axis=1)
b = np.mean(time_clang, axis=1)
c = np.mean(time_icx, axis=1)


compilo = ["gcc", "clang", "icx"]
optimisation = {
	# 'Base' : (0.272, 0.259, 0.303),
	# 'Base' : (11.001, 11.542, 9.893),
    'Aligned': (a[0], b[0], c[0]),
    'Unrolling': (a[1], b[1], c[1]),
    'Intrinsics': (a[2], b[2], c[2]),
    'Parallel aligned': (a[3], b[3], c[3]),
    'Parallel unrolling': (a[4], b[4], c[4]),
    'Parallel intrinsics': (a[5], b[5], c[5]),
}
x = np.arange(len(compilo))  # the label locations
width = 0.1  # the width of the bars
multiplier = 0

fig, ax = plt.subplots(constrained_layout=True)

for attribute, measurement in optimisation.items():
    offset = width * multiplier
    rects = ax.bar(x + offset, measurement, width, label=attribute)
    ax.bar_label(rects, fmt='%.3f', padding=6)
    multiplier += 1

ax.set_xlabel('Compiler')
ax.set_ylabel('Bandwidth [GB/s]')
ax.set_xticks(x + 0.25, compilo)
ax.legend(loc='upper left', ncols=3)

plt.show()

time_scale = np.zeros((3, 9))
bw_scale = np.zeros((3, 9))
i = 0
for name in ["time_align", "time_unroll", "time_intrin"]:
	data = []
	with open(name+"_scale_gcc.txt", "r") as file:
		rows = file.readlines()
		for row in rows:
			data.append(row.strip().split(" "))
	data = np.array(data, dtype=float)
	elapsed = data[:,0]
	bw = data[:,1]
	time_scale[i] = [np.mean(time_gcc, axis=1)[i], np.mean(elapsed[0:31]), np.mean(elapsed[31:62]), np.mean(elapsed[62:93]), np.mean(elapsed[93:124]), np.mean(elapsed[124:155]), np.mean(elapsed[155:165]), np.mean(elapsed[165:175]), np.mean(elapsed[175:185])]
	bw_scale[i] = [np.mean(bw_gcc, axis=1)[i], np.mean(bw[0:31]), np.mean(bw[31:62]), np.mean(bw[62:93]), np.mean(bw[93:124]), np.mean(bw[124:155]), np.mean(bw[155:165]), np.mean(bw[165:175]), np.mean(bw[175:185])]
	i += 1


s = 2**np.arange(0, 9)

fig = plt.figure()
plt.plot(s, bw_scale[0], marker="o", label="align+omp")
plt.plot(s, bw_scale[1], marker="o", label="unroll+omp")
plt.plot(s, bw_scale[2], marker="o", label="intrin+omp")
plt.xscale('log', base=2)
plt.xlabel("Nombre de threads OpenMP")
# plt.ylabel("Temps d'exécution [s]")
plt.ylabel("Débit [Go/s]")
plt.legend(loc='best')
plt.show()
