#!/usr/bin/awk -f
#

/^TX/ {
    time = $14
    tx += 1
}

/^RX/ {
    node = $12
    goodput[node] += $8 * 8
    rx += 1
}

/^PHY_RX/ {
    node = $5
    sinr[node] += $11 
    count[node]++
}

END{
    for (node in goodput) {
        sum_goodput += goodput[node]/time
        sum_quad_goodput += (goodput[node]/time)^2
        n += 1
    }
        for (node in sinr) {
        sum_sinr += sinr[node]/count[node]
        m++
    }
    plr = (tx-rx) / tx * 100
    quad_sum_goodput = sum_goodput^2
    avg_goodput = sum_goodput/n
    fi = quad_sum_goodput/(n*sum_quad_goodput)
    avg_sinr = sum_sinr/m
    printf("Total goodput (bps): %2.9lf\n",sum_goodput);
    printf("Average goodput per UE (bps): %2.9lf\n",avg_goodput);
    printf("Fairness Index (0 to 1): %2.9lf\n",fi);
    printf ("Packet loss ratios (%) %f\n", plr);
    printf("Average SINR per UE (dB): %.9f\n", avg_sinr);
}
