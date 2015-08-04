require 'spec_helper'
require 'ruby_simplex'
include RubySimplex
# From https://www.youtube.com/watch?v=uendv1Khpcw
describe "Example 3" do

  let(:problem) {
    {
      maximize: true,
      function: [10,12],
      technical_restrictions: [
        # x1  x2 ineq free
        [[1,  1], :lt, 100],
        [[1,  3 ], :lt, 270],
      ],
      domain_restriction: [
        [:gt, 0],  #x1
        [:gt, 0],  #x2
      ]
    }
  }

  let(:tableau) { initial_tableau(problem) }

  describe "#initial_tableau(problem)" do
    it { expect(tableau).to eq [[1, -10, -12, 0, 0, 0],
                               [0, 1, 1, 1, 0, 100],
                               [0, 1, 3, 0, 1, 270]] }
  end


  describe "First iteration" do
    let(:in_tableau) { initial_tableau(problem) }
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(-12)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 2 }
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq [0.0, 0.3333333333333333, 1.0, 0.0, 0.3333333333333333, 90.0] }
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 3 }
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq  [[1.0, -6.0, 0.0, 0.0, 4.0, 1080.0],
                                       [0.0, 0.6666666666666667, 0.0, 1.0, -0.3333333333333333, 10.0],
                                       [0.0, 0.3333333333333333, 1.0, 0.0, 0.3333333333333333, 90.0]]}
      it { expect(optimal_solution?(out_tableau)).to be_falsey }

    end
  end

  describe "Second iteration" do
    let(:ini_tableau) { initial_tableau(problem) }
    let(:in_tableau)  { simplex_iteration(ini_tableau)}
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(-6)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 1 }
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 0.6666666666666667 }
    end

    describe "#linha_que_sai" do
      it { expect( linha_que_sai(in_tableau)).to eq [ 0.0, 0.6666666666666667, 0.0, 1.0, -0.3333333333333333, 10.0 ]}
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq [0.0, 1.0, 0.0, 1.4999999999999998, -0.4999999999999999, 14.999999999999998] }
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq [[1.0, 0.0, 0.0, 8.999999999999998, 1.0000000000000009, 1170.0],
                                      [0.0, 1.0, 0.0, 1.4999999999999998, -0.4999999999999999, 14.999999999999998],
                                      [0.0, 0.0, 1.0, -0.4999999999999999, 0.49999999999999994, 85.0]] }
      it { expect(optimal_solution?(out_tableau)).to be_truthy }
    end
  end
end
