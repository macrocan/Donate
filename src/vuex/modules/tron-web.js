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
  async GET_DEPLOYED_CONTRACT({ state }) {
    const instance = state.factoryInstance
    const array = await instance.getDeployedContracts().call()
    console.log(array)
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
  }
}

export default {
  state,
  actions,
  getters,
  mutations
}