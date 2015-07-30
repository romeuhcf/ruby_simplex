require "ruby_simplex/version"

module RubySimplex
  def identity_vector(length, identity_index)
    fail( ArgumentError, "Array index out of bound #(Array) = #{length}, i = #{identity_index}}") unless (0...length).include?(identity_index)
    Array.new(length,0).tap do |me|
      me[identity_index] = 1
    end
  end

  def restriction_with_folgas(restrictions)
    restrictions.each_with_index.map do |row, i|
      [0] + row.first + identity_vector(restrictions.size, i) + [row.last]
    end
  end

  def initial_tableau(problem)
    [function_vector(problem)] + restriction_with_folgas(problem[:technical_restrictions])
  end

  def vector_scalar_product(vector, by)
    vector.map{|i| i * by}
  end

  def function_vector(problem)
    [1] + vector_scalar_product(problem[:function], -1) + Array.new(problem[:technical_restrictions].size, 0) + [0]
  end


  def variavel_que_entra(tableau)
    tableau.first[idx_variavel_que_entra(tableau)]
  end

  def idx_variavel_que_entra(tableau)
    tableau.first.find_index(tableau.first.min)
  end

  def indice_do_menor_coefficiente_positivo(coefficients)
    coefficients = coefficients.map{|i| i < 0 ? Float::INFINITY : i }
    coefficients.find_index(coefficients.min)
  end

  def idx_pivot_col(tableau)
    idx_variavel_que_entra(tableau)
  end

  def pivot_value(tableau)
    tableau[idx_pivot_line(tableau)][idx_pivot_col(tableau)]
  end

  def linha_pivot_atual(tableau)
    tableau[idx_pivot_line(tableau)]
  end

  def nova_linha_pivot(tableau)
    vector_scalar_product( linha_pivot_atual(tableau), 1.0/pivot_value(tableau))
  end

  def vector_sum(v1, v2)
    raise "Different dimension vectors" if v1.size != v2.size
    v1.each_with_index.map {|val, i| val + v2[i]  }
  end

  def calculate_new_line(line_idx, tableau, pivot, idx_pivot_col)
    coefficient = tableau[line_idx][idx_pivot_col]
    coefficient = -1 * coefficient # XXX sempre?
    product_vector = vector_scalar_product(pivot, coefficient)
    vector_sum(tableau[line_idx], product_vector)
  end

  def simplex_iteration(tableau)
    pivot = nova_linha_pivot(tableau)
    pivot_idx = idx_pivot_line(tableau)
    idx_pivot_col = idx_pivot_col(tableau)

    new_tableau = tableau.dup
    0.upto(tableau.size-1) do |line_idx|
      next if line_idx == pivot_idx
      new_tableau[line_idx] = calculate_new_line(line_idx, tableau, pivot, idx_pivot_col)
    end
    new_tableau[pivot_idx] = pivot
    new_tableau
  end

  def idx_pivot_line(tableau)
    pivot_col = idx_variavel_que_entra(tableau)
    coefficients = tableau[1...(tableau.size)].map do |restriction_vector|
      1.0 *  restriction_vector.last / restriction_vector[pivot_col]
    end

    indice_do_menor_coefficiente_positivo(coefficients) + 1
  end

  def optimal_solution?(tableau)
    tableau.first[1, tableau.size - 1].all?{|i| i >= 0}
  end
end


