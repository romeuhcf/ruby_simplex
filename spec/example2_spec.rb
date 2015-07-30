require 'spec_helper'
require 'ruby_simplex'
include RubySimplex
# From https://www.youtube.com/watch?v=hEydYbkGBJE
describe "Example 2" do

  let(:problem) {
    {
      maximize: true,
      function: [2,3,1],
      technical_restrictions: [
        # x1  x2  x3 ineq free
        [[1,  1, 1], :lt, 40],
        [[2,  1, -1], :lt, 20],
        [[3,  2, -1], :lt, 30]
      ],
      domain_restriction: [
        [:gt, 0],  #x1
        [:gt, 0],  #x2
        [:gt, 0]   #x3
      ]
    }
  }

  let(:tableau) { initial_tableau(problem) }

  describe "#initial_tableau(problem)" do
    let(:result) { initial_tableau(problem) }
    it { expect(result).to eq [
      [1,-2, -3, -1, 0, 0, 0,  0],
      [0, 1,  1,  1, 1, 0, 0, 40],
      [0, 2,  1, -1, 0, 1, 0, 20],
      [0, 3,  2, -1, 0, 0, 1, 30]
    ] }
  end

  describe "variavel_que_entra" do
    it { expect(variavel_que_entra(initial_tableau(problem))).to eq(-3)}
  end

  describe "#idx_pivot_line(tableau)" do
    let(:result) { idx_pivot_line(tableau) }
    it { expect(result).to eq 3 }
  end

  describe "#nova_linha_pivot(tableau)" do
    let(:result) { nova_linha_pivot(tableau) }
    it { expect(result).to eq [0, 1.5, 1, -0.5, 0, 0, 0.5, 15] }
  end

  describe "#pivot_value(tableau)" do
    let(:result) { pivot_value(tableau) }
    it { expect(result).to eq 2 }
  end
  describe "#simplex_iteration(tableau)" do
    let(:result) { simplex_iteration(tableau) }
    it { expect(result).to eq [
      [1, 2.5, 0,-2.5,  0, 0,  1.5, 45],
      [0,-0.5, 0, 1.5,  1, 0, -0.5, 25],
      [0, 0.5, 0, -0.5, 0, 1, -0.5, 5],
      [0, 1.5, 1, -0.5, 0, 0,  0.5, 15]
    ] }

    let(:second_result) { simplex_iteration(result) }
    it { expect(second_result).to eq [
      [1.0, 1.6666666666666667, 0.0, 0.0, 1.6666666666666665, 0.0, 0.6666666666666667, 86.66666666666666],
      [0.0, -0.3333333333333333, 0.0, 1.0, 0.6666666666666666, 0.0, -0.3333333333333333, 16.666666666666664],
      [0.0, 0.33333333333333337, 0.0, 0.0, 0.3333333333333333, 1.0, -0.6666666666666666, 13.333333333333332],
      [0.0, 1.3333333333333333, 1.0, 0.0, 0.3333333333333333, 0.0, 0.33333333333333337, 23.333333333333332]]
     }
    it { expect(optimal_solution?(second_result)).to be_truthy }
  end

  describe "#optimal_solution?(tableau)" do
    let(:tableau) { initial_tableau(problem) }
    let(:new_tableau) { simplex_iteration(tableau) }
    let(:result) { optimal_solution?(new_tableau) }
    it { expect(result).to be_falsey }
  end
end
