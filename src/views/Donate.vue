<template>
  <div>
    <div class="donate">
      <h1>{{title}}</h1>
      <p>求助金额：{{amount}}</p>
      <p>desc：{{desc}}</p>
      <p>materialHash：{{materialHash}}</p>
      <p>materialUrl：{{materialUrl}}</p>
    </div>
    <el-form ref="form" :model="form" label-width="80px">
      <el-form-item label="amount" prop="amount" :rules="[
        { required: true, message: '不能为空'},
        { type: 'number', message: '必须为数字值'}
      ]">
        <el-input type="amount" v-model.number="form.amount"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('form')">捐助</el-button>
        <el-button type="default" @click="withDraw">取钱</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'home',
  data() {
      return {
        form: {
          amount: 0
        }
      }
  },
  beforeCreate () {
    console.log(this.$store.state.web3.contractInfo)
  },
  components: {
  },
  methods: {
    onSubmit(){
      this.$store.dispatch('DONATE', this.form.amount)
    },
    withDraw(){
      this.$store.dispatch('WITHDRAW')
    }
  },
  computed: {
    info(){
      return this.$store.state.web3.contractInfo
    },
    title(){
      if (this.info)
        return this.info[1]
      else
        return null
    },
    amount(){
      if (this.info)
        return this.info[0].toString()
      else
        return null
    },
    desc(){
      if (this.info)
        return this.info[2]
      else
        return null
    },
    materialHash(){
      if (this.info)
        return this.info[3].toString(16)
      else
        return null
    },
    materialUrl(){
      if (this.info)
        return this.info[4]
      else
        return null
    }
  }
}
</script>