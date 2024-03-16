using ITensors
let

  N= 16
  Nf= 8
  sites = siteinds("S=1/2",N;conserve_qns=true)


  ampo = OpSum()
  for j=1:N-1
    ampo += "Sz",j,"Sz",j+1
    ampo += 0.5,"S+",j,"S-",j+1
    ampo += 0.5,"S-",j,"S+",j+1
  end
  H = MPO(ampo,sites)
  psi0 = randomMPS(sites, n -> n ≤ Nf ? "up" : "dn")

  sweeps = Sweeps(5)
  setmaxdim!(sweeps, 10,20,100,100,200)
  setcutoff!(sweeps, 1E-10)
  @show sweeps

  energy, psi = dmrg(H,psi0, sweeps)
  println("Final energy = $energy")

  nothing
end
