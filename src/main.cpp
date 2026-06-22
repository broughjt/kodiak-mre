#include <Adapters/PRECiSA.hpp>
#include <kodiak.hpp>

using namespace kodiak;
using namespace kodiak::Adapters::PRECiSA;

int main() {
    kodiak::Kodiak::init();

    kodiak::MinMaxSystem system;

    int d = 20;
    const nat x_index = system.var("x", Interval(1, 20));
    Real x = var(x_index, "x");
    Real zero = val(Interval(0.0));
    Real one = val(Interval(1.0));
    Real p = x - one;
    Real e = aebounddp_sub(x, zero, one, zero);

    for (int i = 2; i <= d; ++i) {
        Real pi = x - val(Interval(double(i)));
        Real ei = aebounddp_sub(x, zero, val(Interval(double(i))), zero);
        e = aebounddp_mul(p, e, pi, ei);
        p = p * pi;
    }

    system.max(e);

    return 0;
}
