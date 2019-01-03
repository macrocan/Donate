
let getTronWeb = async function () {
  const wait = function (){
    if (!window.tronWeb || !window.tronWeb.ready){
      setTimeout(wait,100);
    }
  }
  wait()
  const tronWebState = {
    installed: !!window.tronWeb,
    loggedIn: window.tronWeb && window.tronWeb.ready,
    balance: null,
    address: null,
    instance: null
  }
  if (tronWebState.loggedIn) {
    const tronWeb = window.tronWeb
    const account = await tronWeb.trx.getAccount()
    tronWebState.balance = account.balance
    tronWebState.address = account.address
    tronWebState.instance = tronWeb
    return tronWebState
  } else {
    throw new Error('Unable to connect to TRON wallet')
  }
}

export default getTronWeb