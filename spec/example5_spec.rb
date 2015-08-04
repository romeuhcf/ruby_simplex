require 'spec_helper'

# From https://www.youtube.com/watch?v=Rs2lzo9RDjc
describe "Example 5" do

  let(:problem) {
    {
      maximize: true,
      function: [5,-3,4,-1],
      technical_restrictions: [
        # x1  x2  x3 x4 neq free
        [[1, 1, 1, 1], :lt, 600],
        [[2, 0, 1, 0], :lt, 280],
        [[1, 0, 0, 3], :lt, 150],
      ],
      domain_restriction: [
        [:gt, 0],  #x1
        [:gt, 0],  #x2
        [:gt, 0],  #x3
        [:gt, 0],  #x4
      ]
    }
  }

  let(:tableau) { initial_tableau(problem) }

  describe "#initial_tableau(problem)" do
    it { expect(tableau).to eq [[1, -5, 3, -4, 1, 0, 0, 0, 0], [0, 1, 1, 1, 1, 1, 0, 0, 600], [0, 2, 0, 1, 0, 0, 1, 0, 280], [0, 1, 0, 0, 3, 0, 0, 1, 150]]}
  end


  describe "First iteration" do
    let(:in_tableau) { initial_tableau(problem) }
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(-5)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 2 }
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq [0.0, 1.0, 0.0, 0.5, 0.0, 0.0, 0.5, 0.0, 140.0]}
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 2 }
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq [[1.0, 0.0, 3.0, -1.5, 1.0, 0.0, 2.5, 0.0, 700.0], [0.0, 0.0, 1.0, 0.5, 1.0, 1.0, -0.5, 0.0, 460.0], [0.0, 1.0, 0.0, 0.5, 0.0, 0.0, 0.5, 0.0, 140.0], [0.0, 0.0, 0.0, -0.5, 3.0, 0.0, -0.5, 1.0, 10.0]]}
      it { expect(optimal_solution?(out_tableau)).to be_falsey }

    end
  end
  describe "Second iteration" do
    let(:ini_tableau) { initial_tableau(problem) }
    let(:in_tableau)  { simplex_iteration(ini_tableau)}
    let(:out_tableau)  { simplex_iteration(in_tableau)}

    describe "variavel_que_entra" do
      it { expect(variavel_que_entra(in_tableau)).to eq(-1.5)}
    end

    describe "#idx_pivot_line(tableau)" do
      it { expect( idx_pivot_line(in_tableau)).to eq 2 }
    end

    describe "#pivot_value(tableau)" do
      it { expect(pivot_value(in_tableau)).to eq 0.5 }
    end

    describe "#linha_que_sai" do
      it { expect( linha_que_sai(in_tableau)).to eq [0.0, 1.0, 0.0, 0.5, 0.0, 0.0, 0.5, 0.0, 140.0]}
    end

    describe "#nova_linha_pivot(tableau)" do
      it { expect( nova_linha_pivot(in_tableau)).to eq [0.0, 2.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 280.0]}
    end

    describe "#simplex_iteration(tableau)" do
      it { expect(out_tableau).to eq [[1.0, 3.0, 3.0, 0.0, 1.0, 0.0, 4.0, 0.0, 1120.0], [0.0, -1.0, 1.0, 0.0, 1.0, 1.0, -1.0, 0.0, 320.0], [0.0, 2.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 280.0], [0.0, 1.0, 0.0, 0.0, 3.0, 0.0, 0.0, 1.0, 150.0]]}
      it { expect(optimal_solution?(out_tableau)).to be_truthy }
    end
  end
end

