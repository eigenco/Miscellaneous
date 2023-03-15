clear all
time = 0;
k = linspace(0, 50, 800);
envelope = exp(-.07*(k-12).^2);
velocity = exp(-900*j*k);
psi = envelope.*velocity ;
psi = psi/norm(psi);
potential = [zeros(1, length(k)/2-10) 0.05*ones(1, 20) zeros(1, length(k)/2-10)];
while true
    psi = psi + 1e-3*j*([0 diff(psi, 2) 0] - potential.*psi);
    time = time + 1;
    if mod(time, 5000) == 1
        hold off
        plot3(linspace(-1, 1, 800), real(psi), imag(psi), 'linewidth', 2);
        hold on
        l = linspace(-1, 1, 800);
        c = get(gca, 'colororder');
        plot3([l(391) l(391) l(391) l(391) l(391)], [-0.2 -0.2 0.2 0.2 -0.2], [-0.2 0.2 0.2 -0.2 -0.2], 'color', c(2,:), 'linewidth', 2)
        plot3([l(410) l(410) l(410) l(410) l(410)], [-0.2 -0.2 0.2 0.2 -0.2], [-0.2 0.2 0.2 -0.2 -0.2], 'color', c(2,:), 'linewidth', 2)
        xlim([-1 1])
        ylim([-0.2 0.2])
        zlim([-0.2 0.2])
        view(-10, 30)
        drawnow
        pause(0.01)
    end
end
