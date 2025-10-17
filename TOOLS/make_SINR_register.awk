#!/usr/bin/awk -f
#

/^PHY_RX/ {
    node = $5

    if (node == 3) {
        sinr[i++] = $11
    }
}

END {
    for (n in sinr) {
        printf("%.9f\n", sinr[n]);
    }
}
