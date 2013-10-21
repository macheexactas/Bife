function Test
    import src.*
    n = 5;
    Alpha = 2;
    Beta = 1;
    aminoacids_cant = 62;
    Order = 'CSTPAGNDEQHRKMILVFYW';
    sigma = blosum(aminoacids_cant,'ORDER',Order);
    S = 'CSTPAGNDEQHRKMILVFYW';
    T = 'CSTPAGNDEQHRKMILVFYW';
    Cascade = Cascading(n, Alpha, Beta, sigma, Order, S, T)
    Cascade = Cascade.run_n_Steps(1)
end

