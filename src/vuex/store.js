import Vue from 'vue'
import Vuex from 'vuex'

//import tronWeb from './modules/tron-web'
import web3 from './modules/web3'
Vue.use(Vuex)

export default new Vuex.Store({
	modules: {
		//tronWeb,
		web3
	}
})
