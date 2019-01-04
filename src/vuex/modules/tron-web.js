import * as types from '../types'
import getTronWeb from '../../util/get-tron-web'
import * as factory from '../../util/contract/donate-factory'

/**
 * App通用配置
 */
const state = {
  tronData: {
    installed: false,
    address: null,
    balance: null,
    instance: null
  },
  factoryInstance: null,
  deployedContract: [],
  contractInfo: null
}

const actions = {
  SHOW_LOADING({ commit }, status) {
      commit(types.SHOW_LOADING, status)
  },
  async GET_TRON_INSTANCE({ commit }) {
    try{
      const result = await getTronWeb()
      commit('GET_TRON_WEB_INSTANCE', result)
    }catch(e){
      console.error('error in action registerWeb3', e);
      return Promise.reject(e);
    }
  },
  async GET_FACTORY_INSTANCE({ state, commit }) {
    const tronWeb = state.tronData.instance
    const instance = await tronWeb.contract().at(factory.address)
    commit('GET_FACTORY_INSTANCE', instance)
  },
  async GET_DEPLOYED_CONTRACT({ state, commit }) {
    const instance = state.factoryInstance
    const array = await instance.getDeployedContracts().call()
    commit('GET_DEPLOYED_CONTRACT', array)
  },
  async CREATE_CONTRACT({state}, form) {
    const instance = state.factoryInstance
    const {amount, title, desc, materialHash, materialUrl, donateToAddr} = form
    const result = await instance.createContract(amount, title, desc, materialHash, materialUrl, donateToAddr).send()
    console.log(result)
  },
  async SET_CURRENT_CONTRACT({ state, commit}, index) {
    if (index < state.deployedContract.length){
      const tronWeb = state.tronData.instance
      const address = '41' + state.deployedContract[index].substring(2)
      const base58 = tronWeb.address.fromHex(address)
      console.log(base58)
      const instance = await tronWeb.contract().at(base58)
      const info = await instance.donateInfo().call()
      commit('SET_CURRENT_CONTRACT', info)
    }else
      console.error('invalid index', index)
  }
}


const getters = {
}

const mutations = {
  [types.GET_TRON_WEB_INSTANCE](state, payload) {
    let result = payload
    let tronCopy = state.tronData
    tronCopy.address = result.address
    tronCopy.balance = result.balance
    tronCopy.installed = result.installed
    tronCopy.instance = result.instance
    state.tronData = tronCopy
  },
  [types.GET_FACTORY_INSTANCE](state, payload) {
    state.factoryInstance = payload
  },
  [types.GET_DEPLOYED_CONTRACT](state, array) {
    state.deployedContract = array
  },
  [types.SET_CURRENT_CONTRACT](state, info) {
    state.contractInfo = info
  }
}

export default {
  state,
  actions,
  getters,
  mutations
}