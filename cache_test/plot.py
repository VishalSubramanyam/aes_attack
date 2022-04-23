import matplotlib.pyplot as plt
from numpy import genfromtxt
import sys

for stride in sys.argv[1:]:
    my_data = genfromtxt(f'table{stride}_hm')
    x = my_data[:, 0]
    y = my_data[:, 1]

    plt.plot(x, y, label=f'{stride}')
plt.legend()
plt.savefig('plot_hm.jpg')

plt.clf()

for stride in sys.argv[1:]:
    my_data = genfromtxt(f'table{stride}_median')
    x = my_data[:, 0]
    y = my_data[:, 1]

    plt.plot(x, y, label=f'{stride}')

plt.legend()
plt.savefig('plot_median.jpg')