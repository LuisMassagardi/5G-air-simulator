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
    num_ue = node-1
    printf("%i,", num_ue);
    printf("%2.9lf,",sum_goodput);
    printf("%2.9lf,",avg_goodput);
    printf("%2.9lf,",fi);
    printf ("%f,", plr);
    printf("%.9f\n", avg_sinr);
}
