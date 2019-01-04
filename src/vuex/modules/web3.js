import * as types from '../types'
import getWeb3 from '../../util/get-web3'
import Web3 from 'web3'
import * as factory from '../../util/contract/donate-factory'
import * as donate from '../../util/contract/simple-donate'

/**
 * App通用配置
 */
const state = {
  web3Data: {
    isInjected: false,
    web3Instance: null,
    networkId: null,
    coinbase: null,
    balance: null,
    error: null
  },
  factoryInstance: null,
  deployedContract: [],
  contractInfo: null,
  currentIndex: null
}

const actions = {
  SHOW_LOADING({ commit }, status) {
      commit(types.SHOW_LOADING, status)
  },
  GET_WEB3_INSTANCE({ commit }) {
    getWeb3.then(result => {
        commit('GET_WEB3_INSTANCE', result);
        return Promise.resolve();
    }).catch(e => {
        alert('please unlock metamask')
        console.error('error in action registerWeb3', e);
        return Promise.reject(e);
    })
  },
  GET_FACTORY_INSTANCE({ commit }) {
    let web3 = new Web3(window.web3.currentProvider)
    const factoryContract = web3.eth.contract(factory.ABI)
    const instance = factoryContract.at(factory.address)
    commit('GET_FACTORY_INSTANCE', instance)
  },
  async GET_DEPLOYED_CONTRACT({ state, commit }) {
    const instance = state.factoryInstance
    const promise = new Promise((resolve, reject) => {
      instance.getDeployedContracts.call((e, result) =>{
        if (e) reject(e);
        resolve(result);
      })
    })
    const array = await promise
    commit('GET_DEPLOYED_CONTRACT', array)
  },
  async CREATE_CONTRACT({state}, form) {
    const instance = state.factoryInstance
    const account = state.web3Data.coinbase;
    const {amount, title, desc, materialHash, materialUrl, donateToAddr} = form
    const promise = new Promise((resolve, reject) => {
      instance.createContract.sendTransaction(amount, title, desc, materialHash, materialUrl, donateToAddr, {from: account }, (e, result) =>{
        if (e) reject(e);
        resolve(result);
      })
    })
    const result = await promise
    console.log(result)
  },
  async SET_CURRENT_CONTRACT({ state, commit}, index) {
    if (index < state.deployedContract.length){
      let web3 = new Web3(window.web3.currentProvider)
      const address = state.deployedContract[index]
      const contract = web3.eth.contract(donate.ABI)
      const instance = contract.at(address)
      console.log(instance)
      const promise = new Promise((resolve, reject) => {
        instance.donateInfo.call((e, result) =>{
          if (e) reject(e);
          resolve(result);
        })
      })
      const info = await promise
      commit('SET_CURRENT_CONTRACT', {info, index})
    }else
      console.error('invalid index', index)
  },
  async DONATE({state}, amount) {
    const account = state.web3Data.coinbase;
    let web3 = new Web3(window.web3.currentProvider)
    const address = state.deployedContract[state.currentIndex]
    const contract = web3.eth.contract(donate.ABI)
    const instance = contract.at(address)
    const wei = web3.toWei(amount)
    const promise = new Promise((resolve, reject) => {
      instance.donate.sendTransaction({from: account, value: wei }, (e, result) =>{
        if (e) reject(e);
        resolve(result);
      })
    })
    const result = await promise
    console.log(result)
  },
  async WITHDRAW({state}) {
    const account = state.web3Data.coinbase;
    let web3 = new Web3(window.web3.currentProvider)
    const address = state.deployedContract[state.currentIndex]
    const contract = web3.eth.contract(donate.ABI)
    const instance = contract.at(address)
    const promise = new Promise((resolve, reject) => {
      instance.withdraw.sendTransaction({from: account }, (e, result) =>{
        if (e) reject(e);
        resolve(result);
      })
    })
    const result = await promise
    console.log(result)
  },
}


const getters = {
}

const mutations = {
    [types.GET_WEB3_INSTANCE](state, payload) {
        let result = payload;
        let web3Copy = state.web3Data;
        web3Copy.coinbase = result.coinbase;
        web3Copy.networkId = result.networkId;
        web3Copy.balance = parseInt(result.balance, 10);
        web3Copy.isInjected = result.injectedWeb3;
        web3Copy.web3Instance = result.web3;
        state.web3Data = web3Copy;
    },
  [types.GET_FACTORY_INSTANCE](state, payload) {
    state.factoryInstance = payload
  },
  [types.GET_DEPLOYED_CONTRACT](state, array) {
    state.deployedContract = array
  },
  [types.SET_CURRENT_CONTRACT](state, {info, index}) {
    state.contractInfo = info
    state.currentIndex = index
  }
}

export default {
  state,
  actions,
  getters,
  mutations
}