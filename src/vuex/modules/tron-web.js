import * as types from '../types'
import getTronWeb from '../../util/get-tron-web'

/**
 * App通用配置
 */
const state = {
  tronData: {
    installed: false,
    address: null,
    balance: null,
    error: null
  },
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
  }
}

export default {
  state,
  actions,
  getters,
  mutations
}