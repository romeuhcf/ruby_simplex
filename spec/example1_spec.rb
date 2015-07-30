require 'spec_helper'
require 'ruby_simplex'
include RubySimplex
# From https://www.youtube.com/watch?v=OD0BVZbDieY
describe "Example 1" do

  let(:problem) {
    {
      maximize: true,
      function: [3,5],
      technical_restrictions: [
        # x1  x2  ineq free
        [[2,  4], :lt, 10],
        [[6,  1], :lt, 20],
        [[1, -1], :lt, 30]
      ],
      domain_restriction: [
        [:gt, 0],  #x1
        [:gt, 0]    #x2
      ]
    }
  }
  describe "#identity_vector(length, identity_index)" do
    it { expect(identity_vector(3,0)).to eq [1,0,0] }
    it { expect(identity_vector(3,1)).to eq [0,1,0] }
    it { expect(identity_vector(4,1)).to eq [0,1,0,0] }
    it { expect{identity_vector(4,5)}.to raise_error(ArgumentError) }
  end
  describe "#restriction_with_folgas(restrictions)" do
    let(:result) {restriction_with_folgas(problem[:technical_restrictions]) }
    it { expect(result).to eq [
      [0, 2,  4, 1, 0, 0, 10],
      [0, 6,  1, 0, 1, 0, 20],
      [0, 1, -1, 0, 0, 1, 30]
    ] }
  end
  describe "#function_vector(problem)" do
    let(:result) { function_vector(problem) }
    it { expect(result).to eq [1,-3, -5, 0, 0, 0,  0]  }
  end

  describe "#initial_tableau(problem)" do
    let(:result) { initial_tableau(problem) }
    it { expect(result).to eq [
      [1,-3, -5, 0, 0, 0,  0],
      [0, 2,  4, 1, 0, 0, 10],
      [0, 6,  1, 0, 1, 0, 20],
      [0, 1, -1, 0, 0, 1, 30]
    ] }
  end
  describe "idx_variavel_que_entra" do
    it { expect(idx_variavel_que_entra(initial_tableau(problem))).to eq(2)}
  end

  describe "variavel_que_entra" do
    it { expect(variavel_que_entra(initial_tableau(problem))).to eq(-5)}
  end
  describe "#indice_do_menor_coefficiente_positivo(coefficients)" do
    it { expect(indice_do_menor_coefficiente_positivo([10, 20, 30])).to eq 0 }
    it { expect(indice_do_menor_coefficiente_positivo([20, 10, -30])).to eq 1 }
    it { expect(indice_do_menor_coefficiente_positivo([1, -1, 0])).to eq 2 }
  end
  describe "#idx_pivot_line(tableau)" do
    let(:result) { idx_pivot_line(tableau) }
    it { expect(result).to eq 1 }
  end
  let(:tableau) { initial_tableau(problem) }

  describe "#nova_linha_pivot(tableau)" do
    let(:result) { nova_linha_pivot(tableau) }
    it { expect(result).to eq [0, 0.5, 1, 0.25, 0, 0, 2.5] }

  end

  describe "#pivot_value(tableau)" do
    let(:result) { pivot_value(tableau) }
    it { expect(result).to eq 4 }
  end
  describe "#simplex_iteration(tableau)" do
    let(:result) { simplex_iteration(tableau) }
    it { expect(result).to eq [
      [1, -0.5,  -0,  1.25,  0,  0, 12.5],
      [0,  0.5,   1,  0.25,  0,  0,  2.5],
      [0,  5.5,   0, -0.25,  1,  0, 17.5],
      [0,  1.5,   0,  0.25,  0,  1, 32.5]
    ] }

    let(:second_result) { simplex_iteration(result) }
    it { expect(second_result).to eq [
      [1.0, 0.0, 0.0, 1.2272727272727273, 0.09090909090909091, 0.0, 14.090909090909092],
      [0.0, 0.0, 1.0, 0.2727272727272727, -0.09090909090909091, 0.0, 0.909090909090909],
      [0.0, 1.0, 0.0, -0.045454545454545456, 0.18181818181818182, 0.0, 3.181818181818182],
      [0.0, 0.0, 0.0, 0.3181818181818182, -0.2727272727272727, 1.0, 27.727272727272727]
    ] }
    it { expect(optimal_solution?(second_result)).to be_truthy }
  end

  describe "#optimal_solution?(tableau)" do
    let(:tableau) { initial_tableau(problem) }
    let(:new_tableau) { simplex_iteration(tableau) }
    let(:result) { optimal_solution?(new_tableau) }
    it { expect(result).to be_falsey }
  end
end
