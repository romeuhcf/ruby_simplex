require 'spec_helper'

# From https://www.youtube.com/watch?v=0joAFaJZHdY
describe "Example 4" do

  let(:problem) {
    {
      maximize: true,
      function: [2,3,4],
      technical_restrictions: [
        # x1  x2  x3, neq free
        [[1, 1, 1], :lt, 100],
        [[2, 1, 0], :lt, 210],
        [[1, 0, 0], :lt, 80],
      ],
      domain_restriction: [
        [:gt, 0],  #x1
        [:gt, 0],  #x2
        [:gt, 0],  #x3
      ]
    }
  }

  let(:tableau) { initial_tableau(problem) }

  describe "#initial_tableau(problem)" do
    it { expect(tableau).to eq [[1, -2, -3, -4, 0, 0, 0, 0], [0, 1, 1, 1, 1, 0, 0, 100], [0, 2, 1, 0, 0, 1, 0, 210], [0, 1, 0, 0, 0, 0, 1, 80]]}
  end


  describe "First iteration" do
    let(:in_tableau) { initial_tableau(problem) }
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(-4)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 1 }
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq  [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0]}
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 1 }
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq  [[1.0, 2.0, 1.0, 0.0, 4.0, 0.0, 0.0, 400.0], [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0], [0.0, 2.0, 1.0, 0.0, 0.0, 1.0, 0.0, 210.0], [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 80.0]]}
      it { expect(optimal_solution?(out_tableau)).to be_truthy }

    end
  end
=begin
  describe "Second iteration" do
    let(:ini_tableau) { initial_tableau(problem) }
    let(:in_tableau)  { simplex_iteration(ini_tableau)}
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(0)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 1 }
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 1.0 }
    end

    describe "#linha_que_sai" do
      it { expect( linha_que_sai(in_tableau)).to eq  [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0]}
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0]}
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq [[1.0, 2.0, 1.0, 0.0, 4.0, 0.0, 0.0, 400.0], [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0], [0.0, 2.0, 1.0, 0.0, 0.0, 1.0, 0.0, 210.0], [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 80.0]]}
      it { expect(optimal_solution?(out_tableau)).to be_truthy }
    end
  end
=end
end

