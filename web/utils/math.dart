import 'dart:math';

Random rng = new Random(3425483);

double gaussian(num variance) {
    // http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    double r1 = rng.nextDouble();
    double r2 = rng.nextDouble();
    return sqrt(-2 * log(r1) * variance) * cos(2 * PI * r2);
}