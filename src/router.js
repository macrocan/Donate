import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Main from '@/views/Main.vue'

Vue.use(Router)

export default new Router({
  linkActiveClass: 'active',
  routes: [
    {
      path: '/main',
      component: Main,
      children: [
        { path: '/home', component: Home, name: 'home', iconCls: 'icon-a'},
        { 
          path: '/about',
          component: () => import(/* webpackChunkName: "about" */ './views/About.vue'),
          name: 'about',
          iconCls: 'icon-a'
        }
      ]
    },
    {
      path: '/',
      redirect: '/main'
    },
  ]
})
