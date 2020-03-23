\* We include a library which defines a Hermitian operator
ProjToO. This operator, given a qubit in a maximally mixed
state, simulates projection to the |0> basis vector.(We use
this operator instead of measurement as this would create
two probabilistic branches, one in |O> and the other in |1>
basis state, this would double the number of required
resources on the simulating computer.) */
#library "library.libq"

\* On line 2.1, we declare method computeSomething which
declares a qubit variable psi (line 2.2) and allocates a new
qubit and assigns it to variable psi (line 2.3). Then the
qubit is projected to the IO> basis vector (line 2.4) by
the ProjTo0 operator and then turned into I1> by the
Sigma_x operator (line 2.5). Finally, the state of the
variable psi is displayed (line 2.6)*/
qubit computesomething(){
                        qubit psi;
                        psi = new qubit();
                        ProjToO(psi);
                        Sigma_x(psi);
                        dump_q(psi);
                        return psi;
}

\* On line 3.1, we declare method createEPR which creates
two qubits in overall state 1/2(I00>>+ I11>)and returns this
quantum system pair. First, it declares two qubit variables
psi1 and psi2 (line 3.2). Then, a quantum compound system
variable psiEPR, which is composed of quantum systems psi1
and psi2, is declared (line 3.3). On the next two lines
(3.4 and 3.5), two qubits are allocated and assigned to
variables psi1 and psi2. Both qubits are projected to I0>
basis vector (lines 3.6 and 3.7). The following two lines
3.8 and 3.9 create the entanglement by application of the
Hadamard operator to the first qubit and the CNot operator
to both qubits, psi1 being the control qubit and psi2
the target qubit. On line 3.10, the created EPR pair is
returned to the caller. */
qubit@ qubit createEPR(){
                        qubit psi1, psi2;
                        psiEPR aliasfor [psi1, psi2];
                        psi1 = new qubit();
                        psi2 = new qubit();
                        ProjectToO(psi1);
                        ProjectToO(psi2);
                        Had(psi1);
                        CNot(psi1, psi2);
                        return psiEPR;
}

\* On line 4.1, method angela is declared. This method
receives a channel end for transferring integers and a
qubit as arguments. The qubit should be a particle from and EPR
pair as it is used for teleportation. On lines 4.2 and 4.3, two
variables i and phi are declared. The value of phi is obtained as
return value of method computeSomething() call (line 4.4).
On the next line 4.5, qubits phi and auxTeleportState are measured
in Bell basis and the result of measurement is sent over a channel
using its end cO. */

void angela(channelEnd[int] cO,qubit auxTeleport ){
                                                  int i;
                                                  qubit phi;
                                                  phi = computesomething();
                                                  i = measure(BellBasis, phi, auxTeleport);
                                                  send(cO, i);
             }

\* Method bert is declared on line 5.1. This method also
receives a channel end for transferring integers and a qubit
as arguments. The qubit should be a particle from and EPR
pair as it is used for teleportation. On line 5.2, an integer
variable i is declared and a value is received from the given
channel end (line 5.3). On the next lines (from 5.4 to 5.11),
correction is done as required by the teleportation protocol.
Finally the state of received qubit
is displayed (line 5.12). */

void bert(channelEnd[int] c1, qbit stateToTeleportOn) {
                                                      int i;
                                                      i = recv(c1);
                                                      if(i == 1){
                                                                Sigma_z(stateToTeleportOn)
                                                                }
                                                      elseif(i == 2){
                                                                     Sigma_x(stateToTeleportOn)
                                                                     }
                                                      elseif(i == 3){
                                                                     Sigma_x(stateToTeleportOn);
                                                                     Sigma_z(stateToTeleportOn);
                                                               }
                                                      }

\* The main method from which the program is started is
declared on line 6.1. It declares a channel c on line 6.2.
The ends of the channel are idetified as cO and ct. Next,
two qubit variables psi1 and psi2 (line 6.3) and a compound q
uantum system variable psiEPR (line 6.4) are declared. An EPR
pair is created by call to createEPR() method and assigned to
psiEPR variable (line 6.5). This fills also variables psi1 and
psi2 which the variable psiEPR is composed of. Then a channel
capable of transmitting integers is allocated (line 6.6) and
assigned to variable c (this also fills its ends cO and c1).
On the next line (6.7), a new process is started from method
angela and one particle from the EPR pair and one channel end
is passed to it. The other particle and the other channel end
are passed to method bert
on line 6.8. */
void main(){
           channel [int] c withends [cO, c1];
           qbit psi1, psi2;
           psiEPR aliasfor [psi1, psi2];
           psiEPR = createEPR();
           c = new channel[int]();
           fork angela(cO, psil);
           bert(c1, psi2);
           }
