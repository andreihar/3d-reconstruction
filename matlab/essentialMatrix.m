function E = essentialMatrix(F, K1, K2)
    E = K2' * F * K1;
end