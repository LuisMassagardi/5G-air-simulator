#!/usr/bin/awk -f
#

/^PHY_RX/ {
    node = $5
    sinr[node] += $11 
    count[node]++
}

END{
    for (node in sinr) {
        sum_sinr += sinr[node]/count[node]
        n++
    }
    avg_sinr = sum_sinr/n
    printf("avg SINR per UE: %.9f\n", avg_sinr)
}
