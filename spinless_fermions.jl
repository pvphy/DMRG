
using ITensors
let

  N =16
  Nf=8
  U=1.0
  println("nos= $N")
  println("nop= $Nf")
  println("U= $U")
  sites = siteinds("Fermion",N)

  ampo = OpSum()
  for j=1:N-1
    ampo += U ,"Cdag",j,"C",j,"Cdag",j+1,"C",j+1
    ampo += -0.50,"Cdag",j,"C",j+1
    ampo += -0.50,"Cdag",j+1,"C",j
  end

  #PBC
  #ampo += U ,"Cdag",N,"C",N,"Cdag",1,"C",1
  #ampo += -0.50,"Cdag",N,"C",1
  #ampo += -0.50,"Cdag",1,"C",N

  #if you want an overall constant shift of delta in H #ampo += delta,"Id",1

  H = MPO(ampo,sites)

 # psi0 = randomMPS(sites, n -> n ≤ Nf ? "1" : "0")
  psi0 = randomMPS(sites)
  sweeps = Sweeps(7)
  setmaxdim!(sweeps, 10,20,100,100,200,400,400)
  setcutoff!(sweeps, 1E-10)
  @show sweeps

  energy, psi = dmrg(H,psi0, sweeps)
  println("Final energy = $energy")

  nothing
end
# 10 -2.4079537869892369  -2.407953782205783
# 12 -2.6240065081655635  -2.624006440310338
# 14 -2.8255316403388711  -2.8255074515471073

# 10,20,100,100,200,400)

# julia test_spinless.jl
