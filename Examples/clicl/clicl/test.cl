__kernel void vector_add (global float *vec_a,
                          global float *vec_b,
                          global float *res) {
	const size_t idx = get_global_id(0);
	res[idx] = vec_a[idx] + vec_b[idx];
}

__kernel void write_id_map (global unsigned int *dst) {
	const size_t idx = get_global_id(0);
	dst[idx] = idx;
}