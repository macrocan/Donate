import Vue from 'vue'
import Vuex from 'vuex'

import tronWeb from './modules/tron-web'
Vue.use(Vuex)

export default new Vuex.Store({
	modules: {
		tronWeb
	}
})
