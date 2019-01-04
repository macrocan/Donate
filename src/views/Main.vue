<template>
  <el-container>
    <el-header class="header">
      <Header/>
    </el-header>
    <el-container>
      <el-aside width="200px">
        <NavMenu/>
      </el-aside>
      <el-main>
        <div class="content">
          <div class="section">
            <router-view></router-view>
          </div>
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import NavMenu from '@/components/NavMenu'
import Header from '@/components/Header'

export default {
  name: '',
  components: {
    NavMenu,
    Header
  },
  async beforeCreate () {
    console.log('register tron web Action dispatched from Home.vue')
    if (!this.$store.state.tronWeb.tronData.instance){
      await this.$store.dispatch('GET_TRON_INSTANCE')
      await this.$store.dispatch('GET_FACTORY_INSTANCE')
    }
  },
  computed: {

  }
}

</script>

<style>
.header {
  background-color: #409EFF;
  color: #fff;
  line-height: 60px;
}
</style>